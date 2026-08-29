#!/bin/bash

set -euxo pipefail

packages=(
  bash
  black
  clang-format
  cmake
  coreutils
  fzf
  git
  gnupg
  go
  helm
  htop
  jq
  kind
  kubecolor
  kubectx
  kubernetes-cli
  neovim
  nmap
  node
  pandoc
  prettier
  pyenv
  qemu
  ripgrep
  shellcheck
  shfmt
  stylua
  terraform
  tmux
  tree
  tree-sitter-cli
  vim
  watch
  wget
  yamlfmt
  yq
)

casks=(
  bitwarden
  font-dejavu-sans-mono-nerd-font
  iterm2
  monitorcontrol
)

if ! command -v brew >/dev/null 2>&1; then
  echo 'Error: Homebrew is not installed; see https://brew.sh' >&2
  exit 1
fi

brew update
brew install "${packages[@]}"
brew install --cask "${casks[@]}"
