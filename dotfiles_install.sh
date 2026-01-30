#!/bin/bash

set -eu
set -o pipefail

cd -- "$(dirname -- "$(readlink -f -- "$0")")" >/dev/null 2>&1

dotfiles_run_function() {
  local name=$1
  local func=$2
  shift 2

  script="./dotfiles_install.d/$name.sh"

  if [[ ! -f "$script" ]]; then
    echo "Error: $script not found" >&2
    return 1
  fi

  (
    # shellcheck source=/dev/null
    source "$script"

    if ! declare -f "$func" >/dev/null 2>&1; then
      echo "Error: $func not found in $script" >&2
      exit 1
    fi

    "$func" "$@"
    exit $?
  )
}

dotfiles_can_install() {
  if ! dotfiles_run_function "$1" 'dotfiles_can_install' >/dev/null 2>&1; then
    return 1
  fi
  return 0
}

if [[ $# -eq 0 ]]; then
  printf "%-15s %-16s\n" 'COMPONENT_NAME' 'CAN_BE_INSTALLED'
  for file in ./dotfiles_install.d/*.sh; do
    component_name="$(basename "$file" .sh)"
    printf "%-15s %-16s\n" "$component_name" "$(dotfiles_can_install "$component_name" && echo 'yes' || echo 'no')"
  done
  exit 1
fi

logfile="$HOME/.dotfiles_install.log"
rm -f "$logfile" && touch "$logfile"

# Kill the process group whose ID is equal to the PID of this shell
trap 'kill -TERM -- -$$' EXIT

pids=()
last_exit_code=0

for ((i = 1; i <= $#; i++)); do
  component_name=${!i}
  if dotfiles_can_install "$component_name"; then
    dotfiles_run_function "$component_name" 'dotfiles_run_install' >>"$logfile" 2>&1 &
    pids[i]=$! # Last background process PID
  else
    pids[i]=-1 # Invalid PID
  fi
done

printf "%-15s %-13s %9s\n" 'COMPONENT_NAME' 'IS_INSTALLED' 'EXIT_CODE'
for ((i = 1; i <= $#; i++)); do
  component_name=${!i}
  pid=${pids[i]}

  if ((pid < 0)); then
    printf "%-15s %-13s %9s\n" "$component_name" 'skipped' '-'
    continue
  fi

  {
    wait $pid
    exit_code=$?
  } || true

  if ((exit_code != 0)); then
    printf "%-15s %-13s %9s\n" "$component_name" 'error' $exit_code
    last_exit_code=$exit_code
  else
    printf "%-15s %-13s %9s\n" "$component_name" 'yes' 0
  fi
done

exit $last_exit_code
