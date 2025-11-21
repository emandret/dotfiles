#!/bin/bash

dotfiles_can_install() {
  command -v nvim >/dev/null 2>&1
}

dotfiles_run_install() {
  rm -rf ~/.config/nvim && ln -sf "$(pwd)/.config/nvim" ~/.config/nvim
}
