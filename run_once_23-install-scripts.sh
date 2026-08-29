#!/bin/bash
# shellcheck disable=SC2329

set -euxo pipefail

scripts=()
for f in .scripts/*.sh; do
  scripts+=("$f")
done

if ((${#scripts[@]} == 0)); then
  echo 'Error: no scripts found' >&2
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
for s in "${scripts[@]}"; do
  "$s" &
  pids+=("$!")
done
set +m

for i in "${!scripts[@]}"; do
  name="${scripts[i]}"

  exit_code=0
  wait "${pids[i]}" || exit_code=$?

  unset "pids[i]"

  if ((exit_code != 0)); then
    echo "${name} failed: ${exit_code}" >&2
    last_exit_code=$exit_code
  else
    echo "${name} ok"
  fi
done

exit "$last_exit_code"
