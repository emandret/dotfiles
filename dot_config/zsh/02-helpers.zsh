# shellcheck shell=bash

jwt () {
  jq -R 'split(".") | .[0:2] | map(gsub("-"; "+") | gsub("_"; "/") | gsub("%3D"; "=") | @base64d) | map(fromjson)' <<<"${1:-$(cat)}"
}

clang-format-all() {
  clang-tidy **/*.{c,h} -fix -checks='*' -- ${ARCHFLAGS} &&
    clang-format -i -style=file **/*.{c,h}
}
