#!/bin/bash

set -euo pipefail

# Packages too big to install synchronously in 10-apt-packages.sh
packages=(
  pandoc
  texlive-fonts-extra
  texlive-fonts-recommended
  texlive-latex-base
  texlive-latex-extra
)

if ! grep -qsE 'ID=(ubuntu|debian)' /etc/*release*; then
  echo 'Error: not a debian or ubuntu system' >&2
  exit 1
fi

for package in "${packages[@]}"; do
  sudo apt-get -o DPkg::Lock::Timeout=600 -y install "${package}" ||
    echo "Warning: ${package} unavailable in the configured repositories, skipped" >&2
done
