#!/bin/bash

set -eux

cd "$(dirname "$(readlink -f "$0")")"

rm -rf ~/.vim && cp -r .vim ~/.vim
rm -f ~/.vimrc && ln -s .vim/vimrc ~/.vimrc

vim -T dumb --noplugin +PlugInstall +qall
