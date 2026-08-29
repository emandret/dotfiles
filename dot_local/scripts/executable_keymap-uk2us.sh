#!/bin/bash

set -euo pipefail

# Keycodes obtained from https://developer.apple.com/library/archive/technotes/tn2450/_index.html
readonly src_keymaps=(
  0x64
)

readonly dst_keymaps=(
  0x35
)

if ((${#src_keymaps[@]} != ${#dst_keymaps[@]})); then
  echo 'Error: src_keymaps and dst_keymaps must have equal lengths' >&2
  exit 1
fi

# hidutil replaces the whole UserKeyMapping on every --set, so send all pairs at once
mappings=()

for i in "${!src_keymaps[@]}"; do
  src="$(printf '0x%x' $((0x700000000 | src_keymaps[i])))"
  dst="$(printf '0x%x' $((0x700000000 | dst_keymaps[i])))"

  mappings+=("{\"HIDKeyboardModifierMappingSrc\":${src},\"HIDKeyboardModifierMappingDst\":${dst}}")
done

joined="$(
  IFS=,
  printf '%s' "${mappings[*]}"
)"

hidutil property --set "{\"UserKeyMapping\":[${joined}]}" >/dev/null
