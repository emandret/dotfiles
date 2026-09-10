#!/usr/bin/env python3
"""approve-compound-bash.py -- PreToolUse hook for Claude Code

Auto-approves compound Bash commands (&&, ||, ;, pipes, subshells, etc.)
when every sub-command matches the allow list and none match the deny list.

Flow:
  Simple command           -> exit 0 (let normal permissions handle)
  Compound, all allowed    -> approve
  Compound, any denied     -> deny
  Compound, parse failure  -> exit 0 (fall through to native prompt)
  Otherwise                -> exit 0 (fall through to native prompt)

Dependency: shfmt (go install mvdan.cc/sh/v3/cmd/shfmt@latest)
"""

import fnmatch
import json
import os
import re
import subprocess
import sys
from typing import Optional


# ---------------------------------------------------------------------------
# Hook responses -- always to stdout, always exit 0
# ---------------------------------------------------------------------------

def approve():
    json.dump({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "allow",
        }
    }, sys.stdout)
    sys.exit(0)


def deny(reason: str):
    json.dump({
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": reason,
        }
    }, sys.stdout)
    sys.exit(0)


# ---------------------------------------------------------------------------
# shfmt AST walking -- extract command strings from JSON AST
# ---------------------------------------------------------------------------

def word_to_str(word) -> str:
    """Convert a shfmt Word node (which has Parts) to a string."""
    if not isinstance(word, dict):
        return ""
    return "".join(_part_to_str(p) for p in word.get("Parts", []))


def _part_to_str(part) -> str:
    """Convert a shfmt Part node to its string representation."""
    if not isinstance(part, dict):
        return ""
    t = part.get("Type", "")
    if t == "Lit":
        return part.get("Value", "")
    if t == "SglQuoted":
        return "'" + part.get("Value", "") + "'"
    if t == "DblQuoted":
        return '"' + "".join(_part_to_str(p) for p in part.get("Parts", [])) + '"'
    if t == "ParamExp":
        param = part.get("Param")
        return "$" + (param.get("Value", "") if isinstance(param, dict) else "")
    if t in ("CmdSubst", "ProcSubst"):
        return "$(..)"
    if t == "ArithExp":
        return "$((..))"
    return ""


def _find_cmd_substs(node) -> list[str]:
    """Recursively find command/process substitutions and extract their commands."""
    if not isinstance(node, dict):
        return []
    cmds = []
    t = node.get("Type", "")
    if t in ("CmdSubst", "ProcSubst"):
        for s in node.get("Stmts", []):
            cmds.extend(extract_commands(s))
    elif t == "DblQuoted":
        for p in node.get("Parts", []):
            cmds.extend(_find_cmd_substs(p))
    elif t == "ParamExp":
        exp = node.get("Exp")
        if isinstance(exp, dict) and exp.get("Word"):
            cmds.extend(_find_cmd_substs(exp["Word"]))
        repl = node.get("Repl")
        if isinstance(repl, dict):
            for key in ("Orig", "With"):
                if repl.get(key):
                    cmds.extend(_find_cmd_substs(repl[key]))
    elif "Parts" in node:
        for p in node.get("Parts", []):
            cmds.extend(_find_cmd_substs(p))
    return cmds


def extract_commands(node) -> list[str]:
    """Recursively extract individual command strings from a shfmt AST node."""
    if isinstance(node, list):
        result = []
        for item in node:
            result.extend(extract_commands(item))
        return result
    if not isinstance(node, dict):
        return []

    t = node.get("Type", "")
    cmds: list[str] = []

    if t == "File":
        for s in node.get("Stmts", []):
            cmds.extend(extract_commands(s))

    elif t == "Stmt":
        if node.get("Cmd"):
            cmds.extend(extract_commands(node["Cmd"]))
        for redir in node.get("Redirs", []):
            if isinstance(redir, dict) and redir.get("Word"):
                cmds.extend(_find_cmd_substs(redir["Word"]))

    elif t == "CallExpr":
        args = node.get("Args", [])
        parts = [word_to_str(a) for a in args]
        parts = [p for p in parts if p]
        if parts:
            cmd_str = " ".join(parts)
            cmds.append(cmd_str)
            # Recursively expand bash -c / sh -c
            m = re.match(
                r"^(?:env\s+)?(?:/\S+/)?((?:ba)?sh)\s+-c\s+['\"](.+)['\"]$",
                cmd_str,
            )
            if m:
                inner_cmds = parse_compound(m.group(2))
                if inner_cmds:
                    # Replace the outer "bash -c ..." with its inner commands
                    cmds.pop()
                    cmds.extend(inner_cmds)
        # Check args and assigns for command substitutions
        for arg in args:
            cmds.extend(_find_cmd_substs(arg))
        for assign in node.get("Assigns", []):
            if isinstance(assign, dict) and assign.get("Value"):
                cmds.extend(_find_cmd_substs(assign["Value"]))

    elif t == "BinaryCmd":
        cmds.extend(extract_commands(node.get("X")))
        cmds.extend(extract_commands(node.get("Y")))

    elif t in ("Subshell", "Block"):
        for s in node.get("Stmts", []):
            cmds.extend(extract_commands(s))

    elif t == "IfClause":
        for s in node.get("Cond", []):
            cmds.extend(extract_commands(s))
        for s in node.get("Then", []):
            cmds.extend(extract_commands(s))
        if node.get("Else"):
            cmds.extend(extract_commands(node["Else"]))

    elif t in ("WhileClause", "UntilClause"):
        for s in node.get("Cond", []):
            cmds.extend(extract_commands(s))
        for s in node.get("Do", []):
            cmds.extend(extract_commands(s))

    elif t == "ForClause":
        for s in node.get("Do", []):
            cmds.extend(extract_commands(s))
        loop = node.get("Loop")
        if isinstance(loop, dict):
            for item in loop.get("Items", []):
                cmds.extend(_find_cmd_substs(item))

    elif t == "CaseClause":
        for item in node.get("Items", []):
            if isinstance(item, dict):
                for s in item.get("Stmts", []):
                    cmds.extend(extract_commands(s))

    elif t == "DeclClause":
        for arg in node.get("Args", []):
            if isinstance(arg, dict):
                if arg.get("Value"):
                    cmds.extend(_find_cmd_substs(arg["Value"]))
                arr = arg.get("Array")
                if isinstance(arr, dict):
                    for elem in arr.get("Elems", []):
                        if isinstance(elem, dict) and elem.get("Value"):
                            cmds.extend(_find_cmd_substs(elem["Value"]))

    elif t == "CmdSubst":
        for s in node.get("Stmts", []):
            cmds.extend(extract_commands(s))

    elif t == "TestClause":
        pass  # [[ ... ]] is safe, no sub-commands to check

    else:
        # Fallback: try common fields
        if node.get("Cmd"):
            cmds.extend(extract_commands(node["Cmd"]))
        if node.get("Stmts"):
            for s in node["Stmts"]:
                cmds.extend(extract_commands(s))

    return cmds


# ---------------------------------------------------------------------------
# Compound detection & parsing
# ---------------------------------------------------------------------------

def needs_compound_parse(cmd: str) -> bool:
    """Check if command has metacharacters that could hide sub-commands."""
    for ch in ";&`":
        if ch in cmd:
            return True
    if "&&" in cmd or "||" in cmd:
        return True
    if "$(" in cmd or "<(" in cmd or ">(" in cmd:
        return True
    return False


def parse_compound(cmd: str) -> list[str]:
    """Parse a compound command into sub-commands using shfmt."""
    try:
        result = subprocess.run(
            ["shfmt", "-ln", "bash", "-tojson"],
            input=cmd, capture_output=True, text=True, timeout=10,
        )
    except (FileNotFoundError, subprocess.TimeoutExpired):
        return []
    if result.returncode != 0:
        return []
    try:
        ast = json.loads(result.stdout)
    except json.JSONDecodeError:
        return []
    return [c for c in extract_commands(ast) if c]


# ---------------------------------------------------------------------------
# Permission loading
# ---------------------------------------------------------------------------

def find_git_root() -> Optional[str]:
    try:
        r = subprocess.run(
            ["git", "rev-parse", "--show-toplevel", "--git-dir", "--git-common-dir"],
            capture_output=True, text=True, timeout=5,
        )
        if r.returncode != 0:
            return None
        lines = r.stdout.strip().split("\n")
        if len(lines) >= 3 and lines[1] != lines[2]:
            return os.path.dirname(lines[2])
        return lines[0]
    except (FileNotFoundError, subprocess.TimeoutExpired):
        return None


_BASH_RE = re.compile(r"^Bash\((.+)\)$")


def load_prefixes() -> tuple[list[str], list[str]]:
    """Load Bash allow/deny prefixes from Claude Code settings files.

    Allow entries: strip trailing wildcard syntax (:*, ' *', *) for prefix matching.
    Deny entries: normalize :* to ' *' for glob matching with fnmatch.
    """
    home = os.path.expanduser("~")
    git_root = find_git_root()

    files = [
        os.path.join(home, ".claude", "settings.json"),
        os.path.join(home, ".claude", "settings.local.json"),
    ]
    if git_root:
        files.append(os.path.join(git_root, ".claude", "settings.json"))
        files.append(os.path.join(git_root, ".claude", "settings.local.json"))

    allowed: list[str] = []
    denied: list[str] = []
    seen_allow: set[str] = set()

    for filepath in files:
        try:
            with open(filepath) as f:
                data = json.load(f)
        except (FileNotFoundError, json.JSONDecodeError, PermissionError):
            continue

        perms = data.get("permissions", {})

        for entry in perms.get("allow", []):
            m = _BASH_RE.match(entry)
            if not m:
                continue
            # Strip trailing wildcard syntax to get the command prefix
            prefix = re.sub(r"(?:\s+\*|:\*|\*)$", "", m.group(1))
            if prefix and prefix not in seen_allow:
                allowed.append(prefix)
                seen_allow.add(prefix)

        for entry in perms.get("deny", []):
            m = _BASH_RE.match(entry)
            if not m:
                continue
            # Normalize :* to ' *' so fnmatch works for both styles
            pattern = re.sub(r":(\*)$", r" \1", m.group(1))
            denied.append(pattern)

    return allowed, denied


# ---------------------------------------------------------------------------
# Matching
# ---------------------------------------------------------------------------

_ENV_VAR_RE = re.compile(r"^[A-Za-z_]\w*=\S+\s+")


def _strip_env_prefix(cmd: str) -> str:
    """Strip leading VAR=value assignments from a command."""
    while True:
        m = _ENV_VAR_RE.match(cmd)
        if m:
            cmd = cmd[m.end():]
        else:
            break
    return cmd


def matches_allow(cmd: str, prefixes: list[str]) -> bool:
    """Check if command matches any allow prefix."""
    candidates = {cmd}
    stripped = _strip_env_prefix(cmd)
    if stripped != cmd:
        candidates.add(stripped)
    for c in candidates:
        for prefix in prefixes:
            if c == prefix or c.startswith(prefix + " ") or c.startswith(prefix + "/"):
                return True
    return False


def matches_deny(cmd: str, patterns: list[str]) -> bool:
    """Check if command matches any deny pattern (using glob matching)."""
    candidates = {cmd}
    stripped = _strip_env_prefix(cmd)
    if stripped != cmd:
        candidates.add(stripped)
    for c in candidates:
        for pattern in patterns:
            if fnmatch.fnmatch(c, pattern):
                return True
    return False


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    try:
        data = json.load(sys.stdin)
    except json.JSONDecodeError:
        sys.exit(0)

    command = data.get("tool_input", {}).get("command", "")
    if not command.strip():
        sys.exit(0)

    # Simple commands -- let normal permission rules handle
    if not needs_compound_parse(command):
        sys.exit(0)

    # Check shfmt is available
    try:
        subprocess.run(
            ["shfmt", "--version"], capture_output=True, timeout=5,
        )
    except (FileNotFoundError, subprocess.TimeoutExpired):
        # Can't parse without shfmt -- fall through to prompt
        sys.exit(0)

    # Load permission prefixes from settings
    allowed_prefixes, denied_patterns = load_prefixes()
    if not allowed_prefixes:
        sys.exit(0)

    # Parse compound command into sub-commands
    sub_commands = parse_compound(command)
    if not sub_commands:
        # Parse failed -- fall through to native prompt (don't auto-approve
        # something we can't understand)
        sys.exit(0)

    # Deny if any sub-command matches deny list
    for cmd in sub_commands:
        if matches_deny(cmd, denied_patterns):
            deny(
                f"Compound command contains denied sub-command: {cmd}. "
                "Reformulate without the denied command."
            )

    # Approve if ALL sub-commands match allow list
    if all(matches_allow(cmd, allowed_prefixes) for cmd in sub_commands):
        approve()

    # Not all allowed but none denied -- fall through to native prompt
    sys.exit(0)


if __name__ == "__main__":
    main()
