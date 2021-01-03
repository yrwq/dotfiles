syntax enable
filetype on
filetype plugin on
filetype indent on

let g:mapleader="\<Space>"
set clipboard+=unnamedplus
set omnifunc=syntaxcomplete#Complete
scriptencoding utf-8
set encoding=utf-8
set noshowmode
set autoread
set ruler
set showmatch
set mat=2
set magic
set signcolumn=no
set hlsearch
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set autoindent
set lazyredraw
set cursorline
set nocursorcolumn
set ffs=unix,dos,mac
set wrap
set pumheight=10
set nobackup
set nowritebackup
set noswapfile
set completeopt-=preview
set title
set path+=**
set wildmenu
set wildignore+=**/node_modules/**
set wildignore+=**/.git/**

colorscheme cs

autocmd VimResized * wincmd =
autocmd BufWritePre * %s/\s\+$//e
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | Dashboard | endif

set list
set listchars=
set listchars+=tab:›\ ,
set listchars+=trail:•,
set fillchars+=vert:\ ,

set ignorecase
set smartcase
set incsearch
