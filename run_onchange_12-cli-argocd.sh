#!/bin/bash

set -eux

ARGOCD_VERSION=v2.14.11

tmp="$(mktemp -d)"
trap 'rm -rf "${tmp}"' EXIT

curl -fsSL "https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-amd64" -o "${tmp}/argocd"

mkdir -p "${HOME}/.local/bin"
install -m 0755 "${tmp}/argocd" "${HOME}/.local/bin/argocd"
