#!/bin/bash

dotfiles_can_install() {
	command -v git >/dev/null 2>&1
	command -v zsh >/dev/null 2>&1
}

dotfiles_run_install() {
	rm -rf ~/.oh-my-zsh

	git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

	cp .zshrc ~
	cp .zsh_aliases.zsh ~

	sudo chsh -s "$(which zsh)" "$(whoami)"
}
