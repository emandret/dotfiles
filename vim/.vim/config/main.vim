" ------------------------------------------------------------------------------
" GENERAL SETTINGS

" Set term to support colors
set term=xterm-256color

" Set encoding to utf-8
scriptencoding utf-8
set encoding=utf-8
setglobal fileencoding=utf-8

" Drawing box vertical bar
if exists('&fillchars')
  set fillchars=vert:\\u2502
endif

" Enable hex colors by default
if has('termguicolors')
  set termguicolors
endif

" Enable syntax highlighting by default
if has('syntax')
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark
colorscheme ron

" Uncomment the following to have Vim jump to the last position when reopening
" a file
if has('autocmd')
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line('$') | exe "normal! g'\"" | endif
endif

" Trim unwanted trailing whitespaces on save
autocmd BufWritePre * %s/\s\+$//e

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype
filetype plugin indent on

" ------------------------------------------------------------------------------
" EDITOR SETTINGS

" Enable mouse support in all modes
set mouse=a

" Allow the backspace key to remove indentation, line breaks, and start of
" insert
set backspace=indent,eol,start

" Use the system clipboard (`*` and `+` registers) for all yank, delete, and
" paste operations
set clipboard^=unnamed,unnamedplus

" Automatically hide unsaved buffers when they are abandoned (instead of
" unloading them or causing an error)
set hidden

" Automatically reload a file if it has been modified outside of Vim
set autoread

" Enable swapfiles to recover unsaved changes if Vim crashes
set swapfile

" Store all swapfiles at this location
set directory=/tmp

" Set the time in milliseconds Vim should wait after a key is pressed to see if
" a mapped sequence is completed
set timeoutlen=200

" Ensure the status line is always displayed at the bottom of the editor
set laststatus=2

" Show the current editing mode in the bottom right corner
set showmode

" Show incomplete commands in the bottom right corner
set showcmd

" Show absolute line numbers on the left side of the editor
set number

" Show line numbers relative to the current cursor position
set relativenumber

" Show the cursor position (line and column numbers) in the status line
set ruler

" Set the folding method to be based on indentation
set foldmethod=indent

" Open top-level folds only
set foldlevelstart=1

" Make searches case-insensitive
set ignorecase

" Make searches case-sensitive if the search pattern includes uppercase
" letters
set smartcase

" Highlight search matches
set hlsearch

" Highlight search matches incrementally as you type the search pattern
set incsearch

" Highlight matching pairs of brackets, curly braces, or parentheses
set showmatch

" Set the width of a tab character in columns
set tabstop=2

" Set how many whitespaces (tabs or spaces) shall be inserted for each level of
" indentation
set shiftwidth=2

" Automatically indent new lines
set autoindent

" Enable smart syntax-based indentation
set smartindent

" Enable soft tabs (convert tabs into spaces)
set expandtab

" Use the `shiftwidth` value for soft tabs (how many spaces to insert or remove
" when tab or backspace is pressed)
set softtabstop=-1

" ------------------------------------------------------------------------------
" KEY MAPPINGS

" Map Ctrl-/ to `:let @/=''`
nnoremap <silent><C-_> :let @/=''<CR>

" Remap jj to escape in insert mode
inoremap jj <Esc>

" Remap j and k to their gj and gk counterparts and vice-versa
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" Disable arrows keys and backspace in normal and visual modes
nnoremap <Left> <Nop>
nnoremap <Down> <Nop>
nnoremap <Up> <Nop>
nnoremap <Right> <Nop>

vnoremap <Left> <Nop>
vnoremap <Down> <Nop>
vnoremap <Up> <Nop>
vnoremap <Right> <Nop>

" Autoclosing
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
inoremap {<CR> {<CR>}<Esc>O
inoremap {;<CR> {<CR>};<Esc>O

" ------------------------------------------------------------------------------
" FILETYPES

" Set filetypes for specific matched buffer names
autocmd BufNewFile,BufReadPost Makefile,*.makefile,*.mk set filetype=make
autocmd BufNewFile,BufReadPost *.h,*.hpp,*.c,*.cc,*.cpp set filetype=cpp
autocmd BufNewFile,BufReadPost Dockerfile,Dockerfile.* set filetype=dockerfile
autocmd BufNewFile,BufReadPost *.tf,*.tfvars set filetype=terraform
autocmd BufNewFile,BufReadPost *.yaml,*.yml set filetype=yaml
autocmd BufNewFile,BufReadPost Jenkinsfile,*.groovy set filetype=groovy

" Use tab indentation for makefile
autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab

" Set formatter for various filetypes
autocmd FileType markdown set equalprg=prettier\ --parser\ markdown
autocmd FileType cpp set equalprg=clang-format\ -style=Microsoft
autocmd FileType python set equalprg=black\ --quiet\ -
autocmd FileType terraform set equalprg=terraform\ fmt\ -
autocmd FileType yaml set equalprg=yamlfmt
