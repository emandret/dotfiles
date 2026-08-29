#!/bin/bash

set -euxo pipefail

if ! command -v npm >/dev/null 2>&1; then
  echo 'Error: npm not installed, skipping global prefix setup' >&2
  exit 0
fi

existing="$(npm config get prefix 2>/dev/null || true)"
builtin_default="$(npm config get prefix --location=builtin 2>/dev/null || true)"

if [[ -n ${existing} && ${existing} != 'undefined' && ${existing} != "${builtin_default}" ]]; then
  echo "Error: npm prefix already set to ${existing}, leaving it alone"
  exit 0
fi

npm config set prefix "${HOME}/.npm-packages"
mkdir -p "${HOME}/.npm-packages"
