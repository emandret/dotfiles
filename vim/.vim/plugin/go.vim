let g:go_fmt_command='goimports'
let g:go_auto_type_info=1
let g:go_fmt_autosave=1
let g:go_info_mode='gopls'
let g:go_gopls_enabled=1
let g:go_fmt_experimental=1

" debug mode
let g:go_debug=['lsp']
let g:go_echo_command_info=1
let g:go_debug_address='127.0.0.1:1905'
let g:go_def_mapping_enabled=0

" restart gopls language server
command! GoRestartGopls call go#lsp#Restart()

