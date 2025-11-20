#!/bin/bash

set -eu
set -o pipefail

cd -- "$(dirname -- "$(readlink -f -- "$0")")" >/dev/null 2>&1

dotfiles_run_function() {
	local component=$1
	local func=$2
	shift 2

	script="./dotfiles_install.d/$component.sh"

	if [[ ! -f "$script" ]]; then
		echo "$script not found" >&2
		return 1
	fi

	(
		# shellcheck source=/dev/null
		source "$script"

		if ! declare -f "$func" >/dev/null 2>&1; then
			echo "$func not found in $script" >&2
			exit 1
		fi

		"$func" "$@"
	)
}

dotfiles_can_install() {
	local component=$1
	shift 1

	if ! dotfiles_run_function "$component" dotfiles_can_install >/dev/null 2>&1; then
		return 1
	fi
	return 0
}

if [[ $# -eq 0 ]]; then
	printf "%-9s %-16s\n" COMPONENT CAN_BE_INSTALLED
	for file in ./dotfiles_install.d/*.sh; do
		component="$(basename "$file" .sh)"
		printf "%-9s %-16s\n" "$component" "$(dotfiles_can_install "$component" && echo yes || echo no)"
	done
	exit 1
fi

pids=()
last_exit_code=0

logfile="$HOME/dotfiles_install.log"
rm -f "$logfile"
touch "$logfile"

for ((i = 1; i <= $#; i++)); do
	component=${!i}
	if dotfiles_can_install "$component"; then
		dotfiles_run_function "$component" dotfiles_run_install >>"$logfile" 2>&1 &
		pids[i]=$!
	else
		pids[i]=-1
	fi
done

printf "%-9s %-12s %-9s\n" COMPONENT IS_INSTALLED EXIT_CODE
for ((i = 1; i <= $#; i++)); do
	component=${!i}
	pid=${pids[i]}

	if [[ $pid -lt 0 ]]; then
		printf "%-9s %-12s %9s\n" "$component" skipped -
		continue
	fi

	wait "$pid"
	exit_code=$?

	if [[ $exit_code -ne 0 ]]; then
		printf "%-9s %-12s %9s\n" "$component" error "$exit_code"
		last_exit_code=$exit_code
	else
		printf "%-9s %-12s %9s\n" "$component" yes 0
	fi
done

exit $last_exit_code
