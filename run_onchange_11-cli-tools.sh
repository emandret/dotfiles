#!/bin/bash

set -euxo pipefail

install_rust() {
  if command -v rustup >/dev/null 2>&1; then
    rustup update
    return 0
  fi

  curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs |
    sh -s -- -y --no-modify-path
}

installers=()
while IFS= read -r fn; do
  installers+=("$fn")
done < <(compgen -A function 'install_' | sort)

if ((${#installers[@]} == 0)); then
  echo 'no install_* functions found' >&2
  exit 1
fi

pids=()
last_exit_code=0

terminate_components() {
  local pid
  for pid in "${pids[@]}"; do
    kill -TERM -- "-${pid}" 2>/dev/null || true
  done
}

trap terminate_components INT TERM ERR

set -m
for installer in "${installers[@]}"; do
  "$installer" &
  pids+=("$!")
done
set +m

for i in "${!installers[@]}"; do
  component_name="${installers[i]#install_}"

  exit_code=0
  wait "${pids[i]}" || exit_code=$?

  unset "pids[i]"

  if ((exit_code != 0)); then
    echo "${component_name} failed: ${exit_code}" >&2
    last_exit_code=$exit_code
  else
    echo "${component_name} ok"
  fi
done

exit "$last_exit_code"
