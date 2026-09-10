#!/bin/bash

set -eux

NERD_FONT_RELEASE=v3.3.0

wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONT_RELEASE}/Hack.zip" -O /tmp/hack.zip
mkdir -p ~/.local/share/fonts/hack
unzip -o /tmp/hack.zip -d ~/.local/share/fonts/hack
rm -f /tmp/hack.zip

fc-cache -f ~/.local/share/fonts
