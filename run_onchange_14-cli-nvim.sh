#!/bin/bash

set -eux

NEOVIM_RELEASE=v0.12.5

prefix="${HOME}/.local"
opt_dir="${prefix}/opt/nvim"

symlinks=(
  bin/nvim
  share/man/man1/nvim.1
  share/applications/nvim.desktop
  share/icons/hicolor/128x128/apps/nvim.png
)

rm -rf "${opt_dir}"
mkdir -p "${opt_dir}"
wget -qO - "https://github.com/neovim/neovim/releases/download/${NEOVIM_RELEASE}/nvim-linux-x86_64.tar.gz" |
  tar xzf - -C "${opt_dir}" --strip-components=1

for file in "${symlinks[@]}"; do
  target="${opt_dir}/${file}"
  link_name="${prefix}/${file}"

  mkdir -p "$(dirname "${link_name}")"
  ln -sfn "${target}" "${link_name}"
done
