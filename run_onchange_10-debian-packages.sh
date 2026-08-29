#!/bin/bash

set -euxo pipefail

packages=(
  xclip

  # shell config in ~/.config/zsh
  git
  fzf
  jq
  kubectx

  # editors
  neovim
  vim

  # required by nvim mason/LSP servers
  nodejs
  npm

  # terminal
  tmux

  # C/C++
  clang-format
  clang-tidy

  # shell
  shellcheck

  # tex
  pandoc
  texlive-fonts-extra
  texlive-fonts-recommended
  texlive-latex-base
  texlive-latex-extra

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

  # XDP/TC and BPF tools
  bpftool
  bpftrace
  xdp-tools # includes xdpdump

  # helpers
  ipcalc
)

optional=(
  kubectl
  kubecolor
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
