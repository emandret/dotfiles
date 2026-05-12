#!/bin/bash

set -eux

packages=(
  xclip
  zsh-syntax-highlighting

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

  # live stats
  iftop

  # helpers
  ipcalc
)
