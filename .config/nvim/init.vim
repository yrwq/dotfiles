" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

Plug 'ap/vim-css-color'
Plug 'tpope/vim-commentary'
Plug 'fehawen/cs.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf.vim'
Plug 'sheerun/vim-polyglot'
Plug 'majutsushi/tagbar'
Plug 'ptzz/lf.vim'
Plug 'rbgrouleff/bclose.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'airblade/vim-gitgutter'
Plug 'sainnhe/gruvbox-material'
Plug 'akinsho/nvim-bufferline.lua'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'
Plug 'lervag/vimtex'
Plug 'romgrk/doom-one.vim'


Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install() }}

" Plug 'ycm-core/YouCompleteMe'

" sudo pacman -S ctags
" pip install pynvim jedi flake8

call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif


" Basic settings
so ~/.config/nvim/settings.vim

" Plugin options
so ~/.config/nvim/plugin_options.vim

" Key bindings
so ~/.config/nvim/keys.vim

" Lanuage specific settings
so ~/.config/nvim/language.vim

