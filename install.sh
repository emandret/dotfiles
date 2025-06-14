#!/bin/bash

set -eu

cd -- "$(dirname -- "$(readlink -f -- "$0")")" &>/dev/null && pwd

brew() {
  if [[ ! -d ~/.local/bin ]]; then
    mkdir -p ~/.local/bin
  fi

  packages=(
    black
    clang-format
    coreutils
    gnupg
    go
    helm
    htop
    jq
    kind
    kubernetes-cli
    libvirt
    nmap
    pandoc
    prettier
    pyenv
    qemu
    shfmt
    terraform
    vim
    watch
    wget
    yamlfmt
    yq
    kubectx
  )

  if [[ "$(uname)" =~ 'Darwin' ]]; then
    brew update && brew upgrade
    brew install "${packages[@]}"
  fi
}

vim() {
  rm -rf ~/.{vim,vimrc,viminfo}

  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  rm -rf ~/.config/vim && ln -sf "$(pwd)/.config/vim" ~/.config/vim
  cp .vimrc ~

  vim -T dumb --noplugin -u ~/.config/vim/plugins/list.vim +PlugInstall +qall
}

nvim() {
  rm -rf ~/.config/nvim && ln -sf "$(pwd)/.config/nvim" ~/.config/nvim
}

zsh() {
  cp .zshrc ~
  cp -r .zsh-custom ~

  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting || true

  sudo chsh -s "$(which zsh)" "$(whoami)"
}

if [[ "$#" -gt 0 ]]; then
  for fn in "$@"; do
    shift
    $fn "$@"
  done
fi
