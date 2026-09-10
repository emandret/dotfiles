#!/bin/bash

set -eu

cd "$(dirname "$(readlink -f "$0")")"

SOURCE_DIR="$(pwd)"
CHEZMOI_CONFIG="${HOME}/.config/chezmoi/chezmoi.toml"

mount_or_remount_home () {
  if [[ ! -d ${ROAMING_HOME} ]]; then
    cp -r "${HOME}" "${ROAMING_HOME}"
  fi

  if ! findmnt -n --mountpoint "${HOME}" >/dev/null; then
    sudo mount -o bind "${ROAMING_HOME}" "${HOME}"
  else
    sudo mount -o bind,remount "${ROAMING_HOME}" "${HOME}"
  fi
}

install_chezmoi () {
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "${HOME}/.local/bin"
}

git_repo_externals () {
  awk -F'"' '/^\["[^"]+"\]$/ { path = $2 } /type = "git-repo"/ { print path }' \
    "${SOURCE_DIR}/.chezmoiexternal.toml"
}

clear_non_repo_externals () {
  local rel
  local target

  while read -r rel; do
    [[ -n ${rel} ]] || continue
    target="${HOME}/${rel}"

    if [[ ! -e ${target} && ! -L ${target} ]]; then
      continue
    fi
    if [[ -d ${target} && ! -L ${target} && -e ${target}/.git ]]; then
      continue
    fi

    echo "Clearing ${target}: not a git checkout"
    rm -rf "${target}"
  done < <(git_repo_externals)
}

if [[ -n ${ROAMING_HOME:-} ]]; then
  mount_or_remount_home
fi

export PATH="${HOME}/.local/bin:${PATH}"

if ! command -v chezmoi >/dev/null; then
  install_chezmoi
fi

if [[ ! -f ${CHEZMOI_CONFIG} ]]; then
  chezmoi init --source="${SOURCE_DIR}"
fi

clear_non_repo_externals

exec chezmoi apply --source="${SOURCE_DIR}" "$@"
