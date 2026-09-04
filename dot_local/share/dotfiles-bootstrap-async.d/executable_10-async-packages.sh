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

for package in "${packages[@]}"; do
  sudo apt-get -o DPkg::Lock::Timeout=600 -y install "${package}" ||
    echo "Warning: ${package} unavailable in the configured repositories, skipped" >&2
done
