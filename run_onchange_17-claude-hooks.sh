#!/bin/bash

set -eu

settings="${HOME}/.claude/settings.json"
hooks_dir="${HOME}/.claude/hooks"

for hook in approve-compound-bash git-approve kubectl-guard log-permission-request; do
  if [[ ! -x "${hooks_dir}/${hook}.py" ]]; then
    echo "Error: ${hooks_dir}/${hook}.py is missing or not executable" >&2
    exit 1
  fi
done

hooks="$(
  jq -n '
    {
      PreToolUse: [
        {
          matcher: "Bash",
          hooks: [
            { type: "command", command: "~/.claude/hooks/approve-compound-bash.py" },
            { type: "command", command: "~/.claude/hooks/git-approve.py" },
            { type: "command", command: "~/.claude/hooks/kubectl-guard.py" }
          ]
        }
      ],
      PermissionRequest: [
        {
          matcher: "",
          hooks: [
            { type: "command", command: "~/.claude/hooks/log-permission-request.py" }
          ]
        }
      ]
    }
  '
)"

[[ -f "$settings" ]] || printf '{}\n' >"$settings"

tmp="$(mktemp "${settings}.XXXXXX")"
trap 'rm -f "$tmp"' EXIT

jq --argjson hooks "$hooks" '.hooks = $hooks' "$settings" >"$tmp"
mv "$tmp" "$settings"
trap - EXIT

echo "Registered $(jq '[.hooks[][].hooks[]] | length' "$settings") hooks"
