# shellcheck shell=bash

claude () {
  local socket_dir="${XDG_CACHE_HOME:-${HOME}/.cache}/claude/sockets"

  if mkdir -p "${socket_dir}" 2>/dev/null && chmod 700 "${socket_dir}"; then
    command claude --messaging-socket-path "${socket_dir}/$$.sock" "$@"
  else
    command claude "$@"
  fi
}
