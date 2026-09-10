" ------------------------------------------------------------------------------
" PLUGIN CONF

" markdown
let g:markdown_folding=1

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
