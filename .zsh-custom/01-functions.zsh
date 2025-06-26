set -o pipefail

kga() {
  local namespaced=true
  local resources
  local args=()

  for arg in "$@"; do
    case "$arg" in
    --namespaced | --namespaced=true) namespaced=true ;;
    --namespaced=false) namespaced=false ;;
    *) args+=("$arg") ;;
    esac
  done

  resources="$(kubectl api-resources --verbs=list --namespaced=$namespaced -oname | paste -sd, -)" || return 1

  kubectl get "$resources" --show-kind --ignore-not-found "${args[@]}"
}

kge() {
  local args=(
    --all-namespaces
    --sort-by=.lastTimestamp
  )

  if [[ $# -gt 0 ]]; then
    args+=(--field-selector=involvedObject.name="$1" "${@:2}")
  fi

  kubectl get events "${args[@]}"
}

jwt-decode() {
  jq -R 'split(".") | .[0:2] | map(gsub("-"; "+") | gsub("_"; "/") | gsub("%3D"; "=") | @base64d) | map(fromjson)' <<<"${1:-$(cat)}"
}
