unalias kga 2>/dev/null
unalias kge 2>/dev/null

alias kubectl='kubecolor'

alias ip='ip -c'
alias myip='dig +short myip.opendns.com @resolver4.opendns.com'

alias clang-format-all='f(){ clang-tidy **/*.{c,h} -fix -checks="*" -- $ARCHFLAGS && clang-format -i -style=file **/*.{c,h}; unset -f f; }'
