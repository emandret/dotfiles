" ------------------------------------------------------------------------------
" PLUGIN CONF

" onedark
let g:airline_theme='onedark'
colorscheme onedark

" markdown
let g:markdown_folding=1

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

" ale
let g:ale_linters={
      \  'markdown': ['mdl'],
      \  'go': ['gofmt', 'golint', 'go vet', 'golangserver'],
      \  'latex': ['proselint', 'chktex', 'lacheck'],
      \  'tex': ['proselint', 'chktex', 'lacheck'],
      \  'cpp': ['g++']
      \}
