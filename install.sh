#!/bin/bash

set -eu

cd "$(dirname "$(readlink -f "$0")")"

mount_or_remount_home() {
  if [[ ! -d ${ROAMING_HOME} ]]; then
    cp -r "${HOME}" "${ROAMING_HOME}"
  fi

  if ! grep -qs "${HOME}" /proc/self/mountinfo; then
    sudo mount -o bind "${ROAMING_HOME}" "${HOME}"
  else
    sudo mount -o bind,remount "${ROAMING_HOME}" "${HOME}"
  fi
}

install_user_settings() {
  for dir in ./*/; do
    (
      cd "${dir}"; exec ./install.sh
    )
  done
}

if [[ -d ${DEVPOD_PERSISTENT_STORAGE_DEDICATED_MOUNTPATH} ]]; then
  export ROAMING_HOME="${DEVPOD_PERSISTENT_STORAGE_DEDICATED_MOUNTPATH}/${C3_USERNAME}_home"
  mount_or_remount_home
fi

if [[ ! -f ~/.settings_configured ]]; then
  install_user_settings >> ~/.dotfiles_install_log 2>&1
  touch ~/.settings_configured
fi
