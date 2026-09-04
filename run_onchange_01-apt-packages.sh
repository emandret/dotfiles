#!/bin/bash

set -euxo pipefail

packages=(
  # clipboard support
  xclip

  # kubernetes
  kubectl
  kubecolor

  # shell config in ~/.config/zsh
  git
  fzf
  jq
  kubectx

  # github CLI
  gh

  # editors
  neovim
  vim

  # terminal
  tmux

  # C/C++
  clang-format
  clang-tidy

  # shell
  shellcheck
  shfmt

  # kernel/stack introspection
  iproute2  # ip, ss, tc, bridge
  conntrack # inspect kernel connection tracking
  ethtool   # NIC offloads, ring buffers, link

  # live stats
  iftop

  # packet capture
  tshark
  tcpdump

  # TCP/UDP client, port scanning, host discovery
  netcat-openbsd # nc
  nmap           # includes nping, ncat
  fping          # sweep ping
  socat          # socket relay

  # throughput generation
  iperf3

  # path reachability
  mtr-tiny          # continuous traceroute and per-hop loss/latency
  iputils-tracepath # PMTU-aware
  traceroute

  # L2/ARP
  arping # Thomas Habets version (probes by IP or MAC)

  # DNS
  bind9-dnsutils # includes dig, nslookup

  # helpers
  ipcalc
)

optional=(
  # XDP/TC and BPF tools
  bpftool
  bpftrace
  xdp-tools # includes xdpdump

  # required by nvim mason/LSP servers
  nodejs
  npm
)

if ! grep -qsE 'ID=(ubuntu|debian)' /etc/*release*; then
  echo 'Error: not a debian or ubuntu system' >&2
  exit 1
fi

sudo apt-get update
sudo apt-get install -y "${packages[@]}"

for package in "${optional[@]}"; do
  sudo apt-get install -y "$package" ||
    echo "Warning: ${package} unavailable in the configured repositories, skipped" >&2
done
