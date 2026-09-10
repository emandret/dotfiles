#!/bin/bash

set -euxo pipefail

user="$(whoami)"
sudoers_file="/etc/sudoers.d/90-${user}-nopasswd"

if [[ ${user} == *'.'* || ${user} == *'~'* ]]; then
  echo "Error: '${user}' cannot appear in a /etc/sudoers.d filename" >&2
  exit 1
fi

tmp="$(mktemp "${TMPDIR:-/tmp}/sudoers.XXXXXX")"
trap 'rm -f "${tmp}"' EXIT

printf '%s ALL=(ALL) NOPASSWD: ALL\n' "${user}" >"${tmp}"

if ! sudo grep -E '^ *[@#]includedir +(/private)?/etc/sudoers\.d' /etc/sudoers; then
  echo 'Error: /etc/sudoers has no includedir for /etc/sudoers.d' >&2
  exit 1
fi

if sudo cmp -s "${tmp}" "${sudoers_file}"; then
  echo "${sudoers_file} already current"
  exit 0
fi

if ! sudo visudo -cf "${tmp}"; then
  echo 'Error: syntax check FAILED' >&2
  exit 1
fi

sudo install -o 0 -g 0 -m 0440 "${tmp}" "${sudoers_file}"

# Force sudo to re-prompt for password and retry in a non-interactive way
sudo -k
sudo -n true
