#!/bin/bash
# shellcheck disable=SC2329

set -euxo pipefail

REMOTE_IMAGES=(
  nginx:latest
  wbitt/network-multitool:latest
)

if ! command -v docker >/dev/null 2>&1 || ((${#REMOTE_IMAGES[@]} == 0)); then
  exit 0
fi

pids=()

terminate_tasks() {
  local pid
  for pid in "${pids[@]}"; do
    kill -TERM -- "-${pid}" 2>/dev/null || true
  done
}

# Kill all background tasks on CTRL-C
trap terminate_tasks INT TERM ERR

# Enable job control so that every background task (&) gets its own process group
set -m
for img in "${REMOTE_IMAGES[@]}"; do
  \docker pull "${img}" &
  pids+=("$!")
done
set +m

# Wait for all pulls to complete before returning
for i in "${!REMOTE_IMAGES[@]}"; do
  img="${REMOTE_IMAGES[i]}"

  exit_code=0
  wait "${pids[i]}" || exit_code=$?
  unset "pids[i]"

  if ((exit_code != 0)); then
    echo "Error: pulling ${img} failed" >&2
  else
    echo "${img} pulled"
  fi
done
