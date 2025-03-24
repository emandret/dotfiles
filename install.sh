#!/bin/bash

set -eux

DIR=$(cd -- "$(dirname -- "$(readlink -f -- "$0")")" &> /dev/null && pwd)

install_packages() {
  if [[ ! -d ~/.local/bin ]]; then
    mkdir -p ~/.local/bin
  fi

  packages=(
    black
    clang-format
    coreutils
    gnupg
    go
    helm
    htop
    jq
    kind
    kubernetes-cli
    libvirt
    nmap
    pandoc
    prettier
    pyenv
    qemu
    shfmt
    terraform
    vim
    watch
    wget
    yamlfmt
    yq
    kubectx
  )

  if [[ "$(uname)" =~ 'Linux' ]] && [[ -f /etc/os-release ]]; then
    . /etc/os-release
    case "$ID" in
      debian | ubuntu | linuxmint | kali)
        sudo apt update && sudo apt upgrade -y
        sudo apt install -y ${packages[@]}
        ;;
      rhel | centos | fedora | rocky)
        if command -v dnf > /dev/null 2>&1; then
          echo "redhat-based (dnf)"
        else
          echo "redhat-based (yum)"
        fi
        ;;
      suse | opensuse)
        echo "suse-based (zypper)"
        ;;
      arch | manjaro)
        echo "arch-based (pacman)"
        ;;
      gentoo)
        echo "gentoo-based (emerge)"
        ;;
      alpine)
        echo "alpine-based (apk)"
        ;;
      *)
        echo "unknown distribution ($ID)"
        ;;
    esac
  elif [[ "$(uname)" =~ 'Darwin' ]]; then
    brew update && brew upgrade
    brew install ${packages[@]}
  fi
}

install_vim() {
  rm -rf ~/.vim && cp -r .vim ~/.vim
  rm -f ~/.vimrc && ln -s .vim/vimrc ~/.vimrc
  vim -T dumb --noplugin +PlugInstall +qall
}

install_zsh() {
  cp zshrc ~/.zshrc
  sudo chsh -s $(which zsh) $(whoami)
}

if [[ "$#" -gt 0 ]]; then
  for fn in $@; do
    shift
    eval $fn $@
  done
fi
