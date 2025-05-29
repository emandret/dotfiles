" ------------------------------------------------------------------------------
" PLUGIN LIST

call plug#begin('~/.vim/bundle')
  " nord-vim
  Plug 'https://github.com/arcticicestudio/nord-vim.git'
  " nerdtree
  Plug 'https://github.com/preservim/nerdtree.git'
  " vim-airline
  Plug 'https://github.com/vim-airline/vim-airline.git'
  " vim-gitgutter
  Plug 'https://github.com/airblade/vim-gitgutter.git'
  " vim-go
  Plug 'https://github.com/fatih/vim-go.git', { 'do': ':GoInstallBinaries' }
  " ale
  Plug 'https://github.com/dense-analysis/ale.git'
call plug#end()
