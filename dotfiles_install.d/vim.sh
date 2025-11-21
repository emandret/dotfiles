#!/bin/bash

dotfiles_can_install() {
  command -v curl >/dev/null 2>&1
  command -v vim >/dev/null 2>&1
}

dotfiles_run_install() {
  rm -rf ~/.{vim,vimrc,viminfo}

  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  rm -rf ~/.config/vim && ln -sf "$(pwd)/.config/vim" ~/.config/vim
  cp .vimrc ~

  vim -T dumb --noplugin -u ~/.config/vim/plugins/list.vim +PlugInstall +qall
}
