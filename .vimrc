" Uncomment the following to enable syntax highlighting by default.
if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well.
set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file.
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Trim unwanted trailing whitespaces on save
autocmd BufWritePre * %s/\s\+$//e

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
filetype plugin indent on

set showcmd       " Show (partial) command in status line.
set showmatch     " Show matching brackets.
set ignorecase    " Do case insensitive matching
set smartcase     " Do smart case matching
set incsearch     " Incremental search
set autowrite     " Automatically save before commands like :next and :make
set hidden        " Hide buffers when they are abandoned
set mouse=a       " Enable mouse usage (all modes)
set tabstop=2     " Number of columns a tab character has
set shiftwidth=2  " Number of columns a new level of indentation has
set expandtab     " Expand tabs into spaces

" Added for copy/paste support in WSL
if system('uname -r') =~ "microsoft"
  augroup Yank
    autocmd!
    autocmd TextYankPost * :call system('clip.exe', "@")
  augroup END
endif
