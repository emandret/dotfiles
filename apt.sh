#!/bin/bash

set -eu

packages=(
  xclip
  vim-gtk3
  kubectx
)

if ! grep -qsE 'ID=(ubuntu|debian)' /etc/*release*; then
  exit 1
fi

sudo apt update && sudo apt upgrade -y
sudo apt install -y "${packages[@]}"
