#!/bin/bash

set -euxo pipefail

if command -v rustup >/dev/null 2>&1; then
  rustup update
  exit 0
fi

curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs |
  sh -s -- -y --no-modify-path
