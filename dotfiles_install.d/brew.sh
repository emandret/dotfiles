#!/bin/bash

packages=(
  black
  clang-format
  cmake
  coreutils
  fzf
  gnupg
  go
  helm
  htop
  jq
  kind
  kubectx
  libvirt
  neovim
  nmap
  pandoc
  prettier
  pyenv
  qemu
  ripgrep
  shfmt
  stylua
  terraform
  tree
  tree-sitter-cli
  vim
  watch
  wget
  yamlfmt
  yq
)

dotfiles_can_install() {
  if [[ ! "$(uname)" =~ 'Darwin' ]]; then
    return 1
  fi

  command -v brew >/dev/null 2>&1
}

dotfiles_run_install() {
  if [[ ! -d ~/.local/bin ]]; then
    mkdir -p ~/.local/bin
  fi

  brew update && brew upgrade
  brew install "${packages[@]}"
}
