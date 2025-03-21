#!/bin/bash

set -eu

cp tmux.conf ~/.tmux.conf

rm -rf ~/.tmux && mkdir -p ~/.tmux/plugins
git clone https://git.c3.zone/ExtGitHubMirror/tmux-plugins--tpm ~/.tmux/plugins/tpm || true
