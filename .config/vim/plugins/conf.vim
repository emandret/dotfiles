" ------------------------------------------------------------------------------
" PLUGIN CONF

" markdown
let g:markdown_folding=1

" nord-vim
let g:nord_cursor_line_number_background=1
let g:nord_uniform_status_lines=1
let g:nord_bold_vertical_split_line=0
let g:nord_bold=1
let g:nord_italic=1
let g:nord_italic_comments=1

colorscheme nord

" nerdtree
let NERDTreeShowHidden=1

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | wincmd q | endif

nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" vim-airline
set laststatus=0
set noshowmode
set noshowcmd

" vim-gitgutter
let g:gitgutter_map_keys=0

" vim-go
let g:go_fmt_command='goimports'
let g:go_auto_type_info=1
let g:go_fmt_autosave=1
let g:go_info_mode='gopls'
let g:go_gopls_enabled=1
let g:go_fmt_experimental=1

" vim-go debug mode
let g:go_debug=['lsp']
let g:go_echo_command_info=1
let g:go_debug_address='127.0.0.1:1905'
let g:go_def_mapping_enabled=0

" restart gopls language server
command! GoRestartGopls call go#lsp#Restart()

" ale
let g:ale_linters={
  \  'markdown': ['mdl'],
  \  'go': ['gofmt', 'golint', 'go vet', 'golangserver'],
  \  'latex': ['proselint', 'chktex', 'lacheck'],
  \  'tex': ['proselint', 'chktex', 'lacheck'],
  \  'cpp': ['g++']
  \}
