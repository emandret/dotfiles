# shellcheck shell=zsh

kubectl_get_all() {
  local namespaced='true'
  local resources
  local args=()

  for arg in "$@"; do
    case "$arg" in
      --namespaced | --namespaced='true') namespaced='true' ;;
      --namespaced='false') namespaced='false' ;;
      *) args+=("$arg") ;;
    esac
  done

  resources="$(kubectl api-resources --verbs=list --namespaced=$namespaced -oname | paste -sd, -)" || return 1
  kubectl get "$resources" --show-kind --ignore-not-found "${args[@]}"
}

kubectl_get_events() {
  local args=(
    --all-namespaces
    --sort-by=.lastTimestamp
  )

  if [[ $# -gt 0 ]]; then
    args+=(--field-selector=involvedObject.name="$1" "${@:2}")
  fi

  kubectl get events "${args[@]}"
}

unalias kga &>/dev/null
unalias kge &>/dev/null

alias kga=kubectl_get_all
alias kge=kubectl_get_events

alias pns="kubectl config view --minify -o jsonpath='{..namespace}'"
