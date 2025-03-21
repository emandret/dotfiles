" GENERAL SETTINGS

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
colorscheme ron

" uncomment the following to have vim jump to the last position when
" reopening a file
if has('autocmd')
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line('$') | exe "normal! g'\"" | endif
endif

" trim unwanted trailing whitespaces on save
autocmd BufWritePre * %s/\s\+$//e

" uncomment the following to have vim load indentation rules and plugins
" according to the detected filetype
filetype plugin indent on


" EDITOR SETTINGS

" behavior
set mouse=a                         " enable mouse support in all modes
set backspace=indent,eol,start      " allow the backspace key to remove indentation, line breaks, and start of insert
set clipboard^=unnamed,unnamedplus  " use the system clipboard (`*` and `+` registers) for all yank, delete, and paste operations
set hidden                          " automatically hide unsaved buffers when they are abandoned (instead of unloading them or causing an error)
set autoread                        " automatically reload a file if it has been modified outside of Vim
set swapfile                        " enable swapfiles to recover unsaved changes if Vim crashes
set directory=~/.vim/swapfiles      " store all swapfiles at this location
set timeoutlen=200                  " set the time in milliseconds Vim should wait after a key is pressed to see if a mapped sequence is completed

" status
set laststatus=2                    " ensure the status line is always displayed at the bottom of the editor
set showmode                        " show the current editing mode in the bottom right corner
set showcmd                         " show incomplete commands in the bottom right corner

" line numbers
set number                          " show absolute line numbers on the left side of the editor
set relativenumber                  " show line numbers relative to the current cursor position
set ruler                           " show the cursor position (line and column numbers) in the status line

" folding
set foldmethod=indent               " set the folding method to be based on indentation
set foldlevelstart=1                " open top-level folds only

" search
set ignorecase                      " make searches case-insensitive
set smartcase                       " make searches case-sensitive if the search pattern includes uppercase letters
set hlsearch                        " highlight search matches
set incsearch                       " highlight search matches incrementally as you type the search pattern
set showmatch                       " highlight matching pairs of brackets, curly braces, or parentheses

" indentation
set tabstop=2                       " set the width of a tab character in columns
set shiftwidth=2                    " set how many whitespaces (tabs or spaces) shall be inserted for each level of indentation
set autoindent                      " automatically indent new lines
set smartindent                     " enable smart syntax-based indentation
set expandtab                       " enable soft tabs (convert tabs into spaces)
set softtabstop=-1                  " use the `shiftwidth` value for soft tabs (how many spaces to insert or remove when tab or backspace is pressed)


" KEY MAPPINGS

" map ctrl-/ to `:let @/=''`
nnoremap <silent><C-_> :let @/=''<CR>

" remap j and k to their gj and gk counterparts and vice-versa
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" disable arrows keys and backspace except in insert mode
nnoremap <Left> <Nop>
nnoremap <Down> <Nop>
nnoremap <Up> <Nop>
nnoremap <Right> <Nop>
nnoremap <BS> <Nop>

vnoremap <Left> <Nop>
vnoremap <Down> <Nop>
vnoremap <Up> <Nop>
vnoremap <Right> <Nop>
vnoremap <BS> <Nop>

" autoclosing
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
inoremap {<CR> {<CR>}<Esc>O
inoremap {;<CR> {<CR>};<Esc>O


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
autocmd FileType yaml set equalprg=yamlfmt
