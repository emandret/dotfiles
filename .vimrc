scriptencoding utf-8
set encoding=utf-8
setglobal fileencoding=utf-8

" Drawing box vertical bar
if exists("&fillchars")
  set fillchars=vert:\\u2502
endif

" Uncomment the following to enable syntax highlighting by default
if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Trim unwanted trailing whitespaces on save
autocmd BufWritePre * %s/\s\+$//e

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype
filetype plugin indent on

set laststatus=2                " Enable status line
set noshowmode                  " Do not show mode in status line
set number                      " Show line numbers
set relativenumber              " Show relative line numbers
set ruler                       " Show ruler
set showcmd                     " Show command in status line
set noswapfile                  " Disable the swapfile
set showmatch                   " Show matching brackets
set ignorecase                  " Do case insensitive matching
set smartcase                   " Do smart case matching
set autoindent                  " Do automatic indenting
set smartindent                 " Do smart indenting
set hlsearch                    " Highlight search matches
set incsearch                   " Incremental search
set hidden                      " Hide buffers when they are abandoned
set tabstop=4                   " Number of columns a tab character has
set shiftwidth=4                " Number of columns a new level of indentation has
set expandtab                   " Expand tabs into spaces
set smarttab                    " Smart tab insertion on new lines
set backspace=indent,eol,start  " Make backspace behaves as in most other programs
set timeoutlen=200              " Short timeout for commands

" Map CTRL-S to `:let @/ = ""`
nnoremap <silent><C-S> :let @/ = ""<CR>

" Remap j and k to their gj and gk counterparts and vice-versa
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" Disable arrows keys and backspace except in Insert mode
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

" Set filetypes for specific matched buffer names
autocmd BufNewFile,BufReadPost Makefile,*.makefile,*.mk set filetype=make
autocmd BufNewFile,BufReadPost *.h,*.hpp,*.c,*.cc,*.cpp set filetype=cpp
autocmd BufNewFile,BufReadPost Dockerfile,Dockerfile.* set filetype=dockerfile
autocmd BufNewFile,BufReadPost *.tf,*.tfvars set filetype=terraform
autocmd BufNewFile,BufReadPost *.yaml,*.yml set filetype=yaml

" Use tab indentation for Makefile
autocmd FileType make set tabstop=8 shiftwidth=8 softtabstop=0 noexpandtab

" Use two spaces indentation for Markdown
autocmd FileType markdown set tabstop=2 shiftwidth=2 softtabstop=0

" Set formatter for various filetypes
autocmd FileType markdown set equalprg=prettier\ --parser\ markdown
autocmd FileType cpp set equalprg=clang-format\ -style=Microsoft
autocmd FileType python set equalprg=black\ --quiet\ -
autocmd FileType terraform set equalprg=terraform\ fmt\ -
autocmd FileType yaml set equalprg=yamlfmt

" Autoclosing
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
inoremap {<CR> {<CR>}<Esc>O
inoremap {;<CR> {<CR>};<Esc>O

" Enable markdown folding
let g:markdown_folding = 1

" To load plugins using the vim-plug plugin manager you must run `:PlugInstall` and `:UpdateRemotePlugins` on the first start
call plug#begin()
Plug 'bluz71/vim-nightfly-colors', { 'as': 'nightfly' }
Plug 'itchyny/lightline.vim'
Plug 'vim-syntastic/syntastic'
Plug 'airblade/vim-gitgutter'
Plug 'preservim/nerdtree'
Plug 'jasonccox/vim-wayland-clipboard'
call plug#end()

" bluz71/vim-nightfly-colors
colorscheme nightfly

" itchyny/lightline.vim
let g:lightline = { 'colorscheme': 'nightfly', 'enable': { 'statusline': 1, 'tabline': 1, }, 'subseparator': { 'left':  '\uFF5C', 'right': '\uFF5C' }, 'active': { 'left': [ ['mode', 'paste'], ['gitbranch', 'readonly', 'filename', 'modified'] ] }, 'component_function': { 'gitbranch': 'gitbranch#name' } }

" vim-syntastic/syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
if exists("&statusline")
  set statusline+=%#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*
endif
if exists("&completeopt")
  set completeopt-=preview
endif
autocmd CursorMovedI * if pumvisible() == 0 | pclose | endif
autocmd InsertLeave * if pumvisible() == 0 | pclose | endif

" airblade/vim-gitgutter
highlight SignColumn guibg=NONE ctermbg=NONE

" preservim/nerdtree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
