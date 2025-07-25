export PATH=${HOME}/bin:${HOME}/.local/bin:/usr/local/bin:${PATH}

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH=${HOME}/.oh-my-zsh

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  colored-man-pages
  docker
  gitfast
  kubectl
  terraform
  zsh-syntax-highlighting
)

source ${ZSH}/oh-my-zsh.sh

# User configuration
export LANG=en_US.UTF-8

# Source aliases
if [[ -f ~/.zsh_aliases.zsh ]]; then
  source ~/.zsh_aliases.zsh
fi

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR=vim
else
  export EDITOR=nvim
fi

export GPG_TTY=$(tty)
export ANSIBLE_VAULT_PASSWORD_FILE=~/.ansible_vault_password_file

export ARCHFLAGS="-arch $(uname -m)"

# Store npm packages in $HOME
export NPM_PACKAGES=${NPM_PACKAGES:-$HOME/.npm-packages}

if ! grep -q '^prefix=' ~/.npmrc; then
  echo 'prefix=${NPM_PACKAGES}' >>~/.npmrc
fi

# Update both PATH and NODE_PATH for node modules
export PATH=${NPM_PACKAGES}/bin:${PATH}
export NODE_PATH=${NPM_PACKAGES}/lib/node_modules:${NODE_PATH}

# Add GOPATH/bin to PATH for Go binaries
export PATH=$(go env GOPATH)/bin:${PATH}

# Unset MANPATH so we can inherit from /etc/manpath
unset MANPATH
MANPATH=${NPM_PACKAGES}/share/man:$(manpath)

# Completions
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
source <(kubectl completion zsh)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
