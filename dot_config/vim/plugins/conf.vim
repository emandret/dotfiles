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
