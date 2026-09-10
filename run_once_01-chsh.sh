#!/bin/bash

set -euxo pipefail

user="$(whoami)"
zsh_path="$(command -v zsh)"

if [[ "$(uname)" == 'Darwin' ]]; then
  if ! grep -qxF "$zsh_path" /etc/shells; then
    echo "$zsh_path" | sudo tee -a /etc/shells
  fi

  current_shell="$(dscl . -read "/Users/${user}" UserShell | awk '{print $2}')"
else
  current_shell="$(getent passwd "${user}" | cut -d: -f7)"
fi

if [[ "$current_shell" != "$zsh_path" ]]; then
  sudo chsh -s "$zsh_path" "$user"
fi
