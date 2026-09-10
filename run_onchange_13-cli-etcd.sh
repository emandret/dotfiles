#!/bin/bash

set -eux

ETCD_VERSION=v3.6.4

tmp="$(mktemp -d)"
trap 'rm -rf "${tmp}"' EXIT

curl -fsSL "https://github.com/etcd-io/etcd/releases/download/${ETCD_VERSION}/etcd-${ETCD_VERSION}-linux-amd64.tar.gz" -o "${tmp}/etcd.tar.gz"

mkdir -p "${HOME}/.local/bin"
tar xzf "${tmp}/etcd.tar.gz" -C "${HOME}/.local/bin" --strip-components=1 --wildcards 'etcd-*-linux-amd64/etcd*'
