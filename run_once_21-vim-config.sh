#!/bin/bash

set -euxo pipefail

mkdir -p "${HOME}"/.vim/{bundle,swapfiles}

if ! vim -Es -n -T dumb -u "${HOME}/.config/vim/plugins/list.vim" +PlugInstall +qall; then
  echo "Warning: PlugInstall exited non-zero; check plugins in ~/.vim/bundle" >&2
fi

if [[ "$(uname)" == 'Linux' ]] && ! sudo grep -qs '^EDITOR=' /etc/environment; then
  echo "EDITOR=$(command -v vim)" | sudo tee -a /etc/environment
fi
