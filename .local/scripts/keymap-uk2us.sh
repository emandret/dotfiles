#!/bin/bash

# Keycodes obtained from https://developer.apple.com/library/archive/technotes/tn2450/_index.html
keyremap() {
	src=$(printf "0x%x" $((0x700000000 | $1)))
	dst=$(printf "0x%x" $((0x700000000 | $2)))
	hidutil property --set "{\"UserKeyMapping\":[{\"HIDKeyboardModifierMappingSrc\":$src,\"HIDKeyboardModifierMappingDst\":$dst}]}" >/dev/null 2>&1
}

readonly src_keymaps=(
	0x64
)

readonly dst_keymaps=(
	0x35
)

if [[ ! ${#src_keymaps[*]} -eq ${#dst_keymaps[*]} ]]; then
	echo 'Error: src_keymaps and dst_keymaps must have equal lengths' 1>&2
	exit 1
fi

for i in "${!src_keymaps[@]}"; do
	keyremap "${src_keymaps[i]}" "${dst_keymaps[i]}"
done
