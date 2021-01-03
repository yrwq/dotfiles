" Automatic vim-plug installation
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source ~/.config/nvim/init.vim
endif

call plug#begin('~/.config/nvim/plugged')

Plug 'ap/vim-css-color'
Plug 'tpope/vim-commentary'
Plug 'fehawen/cs.vim'
Plug 'scrooloose/nerdtree'
Plug 'fehawen/sl.vim'
Plug 'dense-analysis/ale'
Plug 'glepnir/dashboard-nvim'
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-gitgutter'
Plug 'machakann/vim-sandwich'
Plug 'sheerun/vim-polyglot'
Plug 'Valloric/YouCompleteMe'
Plug 'honza/vim-snippets'
Plug 'majutsushi/tagbar'
Plug 'ptzz/lf.vim'

call plug#end()

" Basic settings
so ~/.config/nvim/settings.vim

" Plugin options
so ~/.config/nvim/plugin_options.vim

" Key bindings
so ~/.config/nvim/keys.vim

" Lanuage specific settings
so ~/.config/nvim/language.vim

