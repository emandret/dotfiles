#!/bin/bash

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

dotfiles_can_install() {
	if [[ ! "$(uname)" =~ 'Darwin' ]]; then
		return 1
	fi

	command -v brew >/dev/null 2>&1
}

dotfiles_run_install() {
	if [[ ! -d ~/.local/bin ]]; then
		mkdir -p ~/.local/bin
	fi

	brew update && brew upgrade
	brew install "${packages[@]}"
}
