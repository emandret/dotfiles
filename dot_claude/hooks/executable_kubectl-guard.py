#!/usr/bin/env python3
"""PreToolUse hook: allow read-only kubectl on any cluster, mutating only on dev."""
import json
import os
import re
import sys

DEFAULT_DEV_PATTERNS = "kind-,minikube,docker-desktop"

DEV_CONTEXT_PATTERNS = [
    p.strip()
    for p in os.environ.get("KUBECTL_GUARD_DEV_CONTEXTS", DEFAULT_DEV_PATTERNS).split(",")
    if p.strip()
]

DEV_NAME_PATTERN = re.compile(r"(^|[.\-_])(dev|test|local)([.\-_]|$)")

# Read-only subcommands - safe on any cluster
READONLY_SUBCOMMANDS = {
    "get", "describe", "logs", "top", "explain",
    "api-resources", "api-versions", "cluster-info",
    "config", "version", "auth",
    "diff", "events",
}


def approve(reason: str):
    json.dump({"hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": "allow",
    }}, sys.stdout)
    sys.exit(0)


def deny(reason: str):
    json.dump({"hookSpecificOutput": {
        "hookEventName": "PreToolUse",
        "permissionDecision": "deny",
        "permissionDecisionReason": reason,
    }}, sys.stdout)
    sys.exit(0)


def is_dev_context(context: str) -> bool:
    """Check if context contains a dev pattern or matches common dev naming."""
    for pattern in DEV_CONTEXT_PATTERNS:
        if pattern in context:
            return True
    return bool(DEV_NAME_PATTERN.search(context))


input_data = json.load(sys.stdin)
command = input_data.get("tool_input", {}).get("command", "")

# Not kubectl - don't interfere
if not re.match(r"^kubectl\b", command):
    sys.exit(0)

# Extract the subcommand (first non-flag token after kubectl)
subcmd = None
for token in command.split()[1:]:
    if not token.startswith("-"):
        subcmd = token
        break

# Commands that don't need a --context flag
CONTEXT_FREE_SUBCOMMANDS = {"config", "version"}
if subcmd in CONTEXT_FREE_SUBCOMMANDS:
    approve(f"Context-free command: {subcmd}")

# Extract --context value (supports --context=foo and --context foo)
ctx_match = re.search(r"--context[= ]+(\S+)", command)
if not ctx_match:
    deny("kubectl requires an explicit --context flag.")

context = ctx_match.group(1)

if is_dev_context(context):
    approve(f"Dev cluster: {context}")
elif subcmd in READONLY_SUBCOMMANDS:
    approve(f"Read-only ({subcmd}) on {context}")
else:
    deny(
        f"Mutating command '{subcmd}' not allowed on non-dev cluster '{context}'. "
        "Read-only commands (get, describe, logs, etc.) are allowed on any cluster. "
        "Mutating commands require a dev context."
    )
