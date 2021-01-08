call plug#begin('~/.config/nvim/plugged')

Plug 'ap/vim-css-color'
Plug 'tpope/vim-commentary'
Plug 'fehawen/cs.vim'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf.vim'
Plug 'sheerun/vim-polyglot'
Plug 'majutsushi/tagbar'
Plug 'ptzz/lf.vim'
Plug 'rbgrouleff/bclose.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'airblade/vim-gitgutter'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Snipptes


Plug 'garbas/vim-snipmate'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'

" Plug 'klen/python-mode'
" Plug 'w0rp/ale'
" Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install() }}

call plug#end()

" Basic settings
so ~/.config/nvim/settings.vim

" Plugin options
so ~/.config/nvim/plugin_options.vim

" Key bindings
so ~/.config/nvim/keys.vim

" Lanuage specific settings
so ~/.config/nvim/language.vim

