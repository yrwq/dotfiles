syntax enable
filetype on
filetype plugin on
filetype indent on

let g:mapleader="\<Space>"
set clipboard+=unnamedplus
set autoread
set ruler
set mat=2
set scrolloff=8
set magic
set hlsearch
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set cursorline
set ffs=unix,dos,mac
set wrap
set pumheight=10
set nobackup
set nowritebackup
set noswapfile
set completeopt=menuone,noselect,noinsert
set shortmess+=c
set title
set wildmenu
set wildignore+=**/.git/**
set formatoptions-=cro

autocmd VimResized * wincmd =
autocmd BufWritePre * %s/\s\+$//e
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

set list
set listchars=
set listchars+=tab:›\ ,
set listchars+=trail:•,
set fillchars+=vert:\ ,

set ignorecase
set smartcase
set incsearch

colorscheme cs

augroup vimrc_autocmds
    autocmd!
    autocmd FileType python,rst,c,cpp highlight Excess ctermbg=Black guibg=Black
    autocmd FileType python,rst,c,cpp match Excess /\%999v.*/
    autocmd FileType python,rst,c,cpp set nowrap
    autocmd FileType python,rst,c,cpp set colorcolumn=999
augroup END
