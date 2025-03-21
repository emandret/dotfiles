#!/bin/bash

set -eu

cp zshrc ~/.zshrc

# Set shell for user
sudo chsh -s "$(which zsh)" "${USER}"
