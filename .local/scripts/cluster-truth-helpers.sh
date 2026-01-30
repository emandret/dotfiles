#!/bin/bash

set -eu
set -o pipefail

cd -- "$(dirname -- "$(readlink -f -- "$0")")/../" >/dev/null 2>&1

_ct_chart_versions() {
  local bundle_file bundle_name chart_version cluster_file

  for o in $1; do
    case $o in
      -h | --help)
        echo "Usage: $PROGRAM_NAME [-c|--count] CHART_NAME" >&2
        return
        ;;
      -c | --count)
        _ct_chart_versions '' "$2" | awk '{print $1}' | sort | uniq -c
        return
        ;;
    esac
  done

  while IFS=' ' read -r -d $'\n' bundle_file _ chart_version; do
    bundle_name="$(grep '^name:' "${bundle_file%%:}" | cut -d ':' -f2 | tr -d ' ')"
    while read -r -d $'\n' cluster_file; do
      printf '%-20s %s\n' "${chart_version//\"/}" "$(basename "$cluster_file" '.yaml')"
    done < <(grep -Irli "chartBundle: $bundle_name" ./data/clusters)
  done < <(grep -Iri "$2" ./data/chart-bundles)
}

_ct_cluster_versions() {
  local cluster_file module_version

  for o in $1; do
    case $o in
      -h | --help)
        echo "Usage: $PROGRAM_NAME [-c|--count]" >&2
        return
        ;;
      -c | --count)
        _ct_cluster_versions '' | awk '{print $1}' | sort | uniq -c
        return
        ;;
    esac
  done

  while IFS=' ' read -r -d $'\n' cluster_file _ module_version; do
    printf '%-20s %s\n' "${module_version//\"/}" "$(basename "${cluster_file%%:}" '.yaml')"
  done < <(grep -Iri 'clusterRef: ' ./data/clusters)
}

_ct_cluster_bastions() {
  find ./data/ospr-k8s -name 'ospr-k8s-*' -type d -printf '%f\n' | sed -e 's/-\([dsp]\)-/-\1./g' -e 's/^/cpebastion1./g' -e 's/$/.c3.zone/g'
}

declare -r PROGRAM_NAME=${0##*/}

opts=()
args=()
while (($# > 0)); do
  case $1 in
    --)
      # End of options
      shift
      break
      ;;
    -*)
      opts+=("$1")
      ;;
    *)
      args+=("$1")
      ;;
  esac
  shift
done

"_ct_${PROGRAM_NAME//-/_}" "${opts[*]:-}" "${args[@]:-}"
