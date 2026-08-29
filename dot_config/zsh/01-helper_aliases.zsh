# shellcheck shell=zsh

jwt_decode() {
  jq -R 'split(".") | .[0:2] | map(gsub("-"; "+") | gsub("_"; "/") | gsub("%3D"; "=") | @base64d) | map(fromjson)' <<<"${1:-$(cat)}"
}

alias jwt=jwt_decode

alias clang-format-all='f(){ clang-tidy **/*.{c,h} -fix -checks="*" -- $ARCHFLAGS && clang-format -i -style=file **/*.{c,h}; unset -f f; }'

