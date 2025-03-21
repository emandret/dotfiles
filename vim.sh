#!/bin/bash

set -eu

# Set the default editor
echo "EDITOR=$(which vim)" | sudo tee -a /etc/environment

# Reset vim config
rm -rf ~/.{vim,vimrc}
mkdir -p ~/.vim/{autoload,bundle,swapfiles}

# Install vim-plug
curl -fsSL -o ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.git.c3.zone/ExtGitHubMirror/junegunn--vim-plug/master/plug.vim

# Install all plugins
vim -Es -n -T dumb -u vim-config/plugins/list.vimrc +PlugInstall +qall

# Copy vim config
if [[ -d ./vim-config ]]; then
  rm -rf ~/.vim-config && cp -r vim-config ~/.vim-config
  cp vimrc ~/.vimrc
fi
