alias ip='ip -c'
alias myip='dig +short myip.opendns.com @resolver4.opendns.com'
alias clang-format-all='f(){ clang-tidy **/*.{c,h} -fix -checks="*" -- $ARCHFLAGS && clang-format -i -style=file **/*.{c,h}; unset -f f; }'

alias kubectl='kubecolor'

alias jwt-decode='jwt_decode'

unalias kga &>/dev/null
unalias kge &>/dev/null
alias kga='kubectl_get_all'
alias kge='kubectl_get_events'

alias wcl='git_worktree_clone'
alias wco='git_worktree_checkout'
alias wrm='git_worktree_remove'
alias wpr='git_worktree_prune'
