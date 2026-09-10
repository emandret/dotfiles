#!/usr/bin/env python3
# Auto-approve git commands with safe subcommands, regardless of
# -C flag positioning. Allowed commands are parsed from the
# Bash(git ...:*) entries in the settings files. Dangerous commands
# fall through to the normal permission prompt.

import json
import re
import subprocess
import sys
from pathlib import Path
from typing import Optional


def approve(reason: str) -> None:
    json.dump(
        {
            "hookSpecificOutput": {
                "hookEventName": "PreToolUse",
                "permissionDecision": "allow",
                "permissionDecisionReason": reason,
            }
        },
        sys.stdout,
    )
    sys.exit(0)


def find_git_root() -> Optional[Path]:
    """Locate the enclosing repo, resolving worktrees to the common root."""
    try:
        r = subprocess.run(
            ["git", "rev-parse", "--show-toplevel", "--git-dir", "--git-common-dir"],
            capture_output=True, text=True, timeout=5,
        )
        if r.returncode != 0:
            return None
        lines = r.stdout.strip().split("\n")
        if len(lines) >= 3 and lines[1] != lines[2]:
            return Path(lines[2]).parent
        return Path(lines[0])
    except (FileNotFoundError, subprocess.TimeoutExpired):
        return None


def settings_files() -> list[Path]:
    """Every settings file Claude Code merges permissions from.

    Must match the list in approve-compound-bash.py, otherwise a single
    'git foo' prompts while 'git foo && git bar' auto-approves.
    """
    home = Path.home() / ".claude"
    files = [home / "settings.json", home / "settings.local.json"]

    git_root = find_git_root()
    if git_root:
        files.append(git_root / ".claude" / "settings.json")
        files.append(git_root / ".claude" / "settings.local.json")

    return files


def load_git_allow_prefixes() -> list[str]:
    """Parse the settings files to extract allowed git command prefixes.

    Looks for Bash(git <prefix>:*) entries in permissions.allow.
    Returns prefixes sorted longest-first so more specific patterns
    (e.g. 'config --get') match before general ones (e.g. 'config').
    """
    prefixes = []
    seen = set()

    for settings_path in settings_files():
        try:
            settings = json.loads(settings_path.read_text())
        except (OSError, json.JSONDecodeError):
            continue

        for entry in settings.get("permissions", {}).get("allow", []):
            m = re.match(r"^Bash\(git (.+?):\*\)$", entry)
            if m and m.group(1) not in seen:
                seen.add(m.group(1))
                prefixes.append(m.group(1))

    # Longest first so "config --get" matches before "config"
    prefixes.sort(key=len, reverse=True)
    return prefixes


def strip_git_global_options(cmd: str) -> str:
    """Strip 'git' prefix and known global options to isolate the rest.

    Handles: git -C <path>, git -c <key=val>, git --git-dir=<path>,
             git --work-tree=<path>, git --no-pager
    """
    s = re.sub(r"^git\s+", "", cmd)
    s = re.sub(r"-C\s+\S+\s*", "", s)
    s = re.sub(r"-c\s+\S+\s*", "", s)
    s = re.sub(r"--git-dir[=\s]\S+\s*", "", s)
    s = re.sub(r"--work-tree[=\s]\S+\s*", "", s)
    s = re.sub(r"--no-pager\s*", "", s)
    return s.strip()


data = json.load(sys.stdin)
command = data.get("tool_input", {}).get("command", "")

# Only handle commands starting with git
if not command.startswith("git "):
    sys.exit(0)

# Don't auto-approve command chains -- they may contain dangerous commands
if re.search(r"&&|\|\||;", command):
    sys.exit(0)

# Take the first command in a pipeline (git log | head is fine)
first_cmd = command.split("|")[0]

args = strip_git_global_options(first_cmd)

for prefix in load_git_allow_prefixes():
    if args == prefix or args.startswith(prefix + " "):
        approve(f"Auto-approved: git {prefix}")

# Everything else (commit, push, pull, reset, rebase, merge, checkout, ...)
# falls through to the normal permission prompt.
sys.exit(0)
