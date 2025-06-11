jwt-decode() {
  jq -R 'split(".") | .[0:2] | map(gsub("-"; "+") | gsub("_"; "/") | gsub("%3D"; "=") | @base64d) | map(fromjson)' <<<"${1:-$(cat)}"
}

kga() {
  local namespaced=true
  local args=()

  for arg in "$@"; do
    case "$arg" in
      --namespaced | --namespaced=true) namespaced=true ;;
      --namespaced=false) namespaced=false ;;
      *) args+=("$arg") ;;
    esac
  done

  local resources
  if ! resources="$(kubectl api-resources --verbs=list --namespaced=$namespaced -oname | paste -sd, -)"; then
    echo 'Failed to retrieve API resources' >&2
    return 1
  fi

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

tigera() {
  local cmd="$1"; shift

  case "$cmd" in
    token)
      kubectl create token tigera-manager -n tigera-manager --duration=84600s
      ;;

    es-user)
      kubectl get secret tigera-secure-es-elastic-user -n tigera-elasticsearch -o go-template='{{.data.elastic | base64decode}}'
      ;;

    egw)
      local egw
      if ! egw="$(kubectl -n egress-gateways get po -l egress-gateway="$1" -o jsonpath='{.items[0].metadata.name}')"; then
        echo 'Failed to retrieve EGW pod name' >&2
        return 1
      fi

      kubectl -n egress-gateways debug -it $egw --image=docker.io/wbitt/network-multitool --target=egress-gateway -- bash
      ;;

    *)
      echo "Usage: $0 <command>"
      echo "Commands:"
      echo "  token       get a long-lived token for tigera-manager"
      echo "  es-user     get the tigera-elasticsearch password"
      echo "  egw <name>  start an ephemeral debug container in the given EGW pod"
      return 1
      ;;
  esac
}
