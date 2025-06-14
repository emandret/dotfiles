" ------------------------------------------------------------------------------
" GENERAL SETTINGS

" set term to support colors
set term=xterm-256color

" set encoding to utf-8
scriptencoding utf-8
set encoding=utf-8
setglobal fileencoding=utf-8

" drawing box vertical bar
if exists('&fillchars')
  set fillchars=vert:\\u2502
endif

" enable hex colors by default
if has('termguicolors')
  set termguicolors
endif

" enable syntax highlighting by default
if has('syntax')
  syntax on
endif

" if using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

" uncomment the following to have vim jump to the last position when reopening
" a file
if has('autocmd')
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line('$') | exe "normal! g'\"" | endif
endif

" trim unwanted trailing whitespaces on save
autocmd BufWritePre * %s/\s\+$//e

" uncomment the following to have vim load indentation rules and plugins
" according to the detected filetype
filetype plugin indent on

" ------------------------------------------------------------------------------
" EDITOR SETTINGS

" enable mouse support in all modes
set mouse=a

" allow the backspace key to remove indentation, line breaks, and start of
" insert
set backspace=indent,eol,start

" use the system clipboard (`*` and `+` registers) for all yank, delete, and
" paste operations
set clipboard^=unnamed,unnamedplus

" automatically hide unsaved buffers when they are abandoned (instead of
" unloading them or causing an error)
set hidden

" automatically reload a file if it has been modified outside of vim
set autoread

" enable swapfiles to recover unsaved changes if vim crashes
set swapfile

" store all swapfiles at this location
set directory=/tmp

" set the time in milliseconds vim should wait after a key is pressed to see if
" a mapped sequence is completed
set timeoutlen=200

" ensure the status line is always displayed at the bottom of the editor
set laststatus=2

" show the current editing mode in the bottom right corner
set showmode

" show incomplete commands in the bottom right corner
set showcmd

" show absolute line numbers on the left side of the editor
set number

" show line numbers relative to the current cursor position
set relativenumber

" show the cursor position (line and column numbers) in the status line
set ruler

" set the folding method to be based on indentation
set foldmethod=indent

" open top-level folds only
set foldlevelstart=20

" make searches case-insensitive
set ignorecase

" make searches case-sensitive if the search pattern includes uppercase
" letters
set smartcase

" highlight search matches
set hlsearch

" highlight search matches incrementally as you type the search pattern
set incsearch

" highlight matching pairs of brackets, curly braces, or parentheses
set showmatch

" set the width of a tab character in columns
set tabstop=2

" set how many whitespaces (tabs or spaces) shall be inserted for each level of
" indentation
set shiftwidth=2

" automatically indent new lines
set autoindent

" enable smart syntax-based indentation
set smartindent

" enable soft tabs (convert tabs into spaces)
set expandtab

" use the `shiftwidth` value for soft tabs (how many spaces to insert or remove
" when tab or backspace is pressed)
set softtabstop=-1

" ------------------------------------------------------------------------------
" KEY MAPPINGS

" map Ctrl-/ to `:let @/=''`
nnoremap <silent><C-_> :let @/=''<CR>

" remap j and k to their gj and gk counterparts and vice-versa
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" disable arrows keys and backspace except in insert mode
nnoremap <Left> <nop>
nnoremap <Down> <nop>
nnoremap <Up> <nop>
nnoremap <Right> <nop>

vnoremap <Left> <nop>
vnoremap <Down> <nop>
vnoremap <Up> <nop>
vnoremap <Right> <nop>

" ------------------------------------------------------------------------------
" FILETYPES

" set filetypes for specific matched buffer names
autocmd BufNewFile,BufReadPost Makefile,*.makefile,*.mk set filetype=make
autocmd BufNewFile,BufReadPost *.h,*.hpp,*.c,*.cc,*.cpp set filetype=cpp
autocmd BufNewFile,BufReadPost Dockerfile,Dockerfile.* set filetype=dockerfile
autocmd BufNewFile,BufReadPost *.tf,*.tfvars set filetype=terraform
autocmd BufNewFile,BufReadPost *.yaml,*.yml set filetype=yaml
autocmd BufNewFile,BufReadPost Jenkinsfile,*.groovy set filetype=groovy

" use tab indentation for makefile
autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab

" set formatter for various filetypes
autocmd FileType markdown set equalprg=prettier\ --parser\ markdown
autocmd FileType cpp set equalprg=clang-format\ -style=Microsoft
autocmd FileType python set equalprg=black\ --quiet\ -
autocmd FileType terraform set equalprg=terraform\ fmt\ -
autocmd FileType yaml set equalprg=yamlfmt\ -
