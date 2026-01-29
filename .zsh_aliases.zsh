set -o pipefail

alias ip='ip -c'
alias myip='dig +short myip.opendns.com @resolver4.opendns.com'

alias clang-format-all='f(){ clang-tidy **/*.{c,h} -fix -checks="*" -- $ARCHFLAGS && clang-format -i -style=file **/*.{c,h}; unset -f f; }'

_jwt_decode() {
  jq -R 'split(".") | .[0:2] | map(gsub("-"; "+") | gsub("_"; "/") | gsub("%3D"; "=") | @base64d) | map(fromjson)' <<<"${1:-$(cat)}"
}

alias jwt-decode='_jwt_decode'

# ----------------------------------------
#   KUBERNETES
# ----------------------------------------

alias kubectl='kubecolor'

_kubectl_get_all() {
  local namespaced='true'
  local resources
  local args=()

  for arg in "$@"; do
    case "$arg" in
      --namespaced | --namespaced='true') namespaced='true'   ;;
      --namespaced='false')               namespaced='false'  ;;
      *)                                  args+=("$arg")      ;;
    esac
  done

  resources="$(kubectl api-resources --verbs=list --namespaced=$namespaced -oname | paste -sd, -)" || return 1
  kubectl get "$resources" --show-kind --ignore-not-found "${args[@]}"
}

_kubectl_get_events() {
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
alias kga='_kubectl_get_all'

unalias kge &>/dev/null
alias kge='_kubectl_get_events'

# ----------------------------------------
#   CLUSTER-TRUTH
# ----------------------------------------

_cluster_truth_chart_versions() {
  local count_only=0
  local bundle_file bundle_name chart_name chart_version cluster_file

  local _opts
  _opts=$(getopt -o c -l count -- "$@") || return 2
  eval set -- "$_opts"

  while true; do
    case "$1" in
      -c|--count) count_only=1; shift                         ;;
      --)         shift; break                                ;;
      *)          echo "internal getopt error" >&2; return 2  ;;
    esac
  done

  chart_name=$1
  if [ -z "$chart_name" ]; then
    echo "usage: $0 [-c|--count] chart_name" >&2
    return 0
  fi

  if (( count_only )); then
    _cluster_truth_chart_versions "$chart_name" | awk '{print $1}' | sort | uniq -c
    return
  fi

  while IFS=' ' read -r -d $'\n' bundle_file _ chart_version; do
    bundle="$(grep '^name:' "${bundle_file%%:}" | cut -d ':' -f2 | tr -d ' ')"
    while read -r -d $'\n' cluster_file; do
      printf '%-20s %s\n' "${chart_version//\"/}" "$(basename "$cluster_file" '.yaml')"
    done < <(grep -Irli "chartBundle: $bundle" ./data/clusters)
  done < <(grep -Iri "$chart_name" ./data/chart-bundles)
}

_cluster_truth_tfe_module_versions() {
  local count_only=0

  local _opts
  _opts=$(getopt -o c -l count -- "$@") || return 2
  eval set -- "$_opts"

  while true; do
    case "$1" in
      -c|--count) count_only=1; shift                         ;;
      --)         shift; break                                ;;
      *)          echo "internal getopt error" >&2; return 2  ;;
    esac
  done

  if (( count_only )); then
    _cluster_truth_tfe_module_versions | awk '{print $1}' | sort | uniq -c
    return 0
  fi

  while IFS=' ' read -r -d $'\n' cluster_file _ module_tag; do
    printf '%-20s %s\n' "${module_tag//\"/}" "$(basename "${cluster_file%%:}" '.yaml')"
  done < <(grep -Iri 'clusterRef: ' ./data/clusters)
}

_cluster_truth_cpebastion_hostnames() {
  find ./data/ospr-k8s -name 'ospr-k8s-*' -type d -printf '%f\n' | sed -e 's/-\([dsp]\)-/-\1./g' -e 's/^/cpebastion1./g' -e 's/$/.c3.zone/g'
}

alias chart-versions='_cluster_truth_chart_versions'
alias cluster-versions='_cluster_truth_tfe_module_versions'
alias cpebastions='_cluster_truth_cpebastion_hostnames'
