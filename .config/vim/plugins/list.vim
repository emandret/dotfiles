" ------------------------------------------------------------------------------
" PLUGIN LIST

call plug#begin('~/.vim/bundle')
  " nord-vim
  Plug 'https://git.c3.zone/ExtGitHubMirror/arcticicestudio--nord-vim.git'
  " nerdtree
  Plug 'https://git.c3.zone/ExtGitHubMirror/preservim--nerdtree.git'
  " vim-airline
  Plug 'https://git.c3.zone/ExtGitHubMirror/vim-airline--vim-airline.git'
  " vim-gitgutter
  Plug 'https://git.c3.zone/ExtGitHubMirror/airblade--vim-gitgutter.git'
  " vim-go
  Plug 'https://git.c3.zone/ExtGitHubMirror/fatih--vim-go.git', { 'do': ':GoInstallBinaries' }
  " ale
  Plug 'https://git.c3.zone/ExtGitHubMirror/dense-analysis--ale.git'
call plug#end()
