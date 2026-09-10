#!/bin/bash

set -eux

if ! command -v npm >/dev/null; then
  echo 'Error: npm is required to install Claude Code' >&2
  exit 1
fi

npm install -g @anthropic-ai/claude-code
