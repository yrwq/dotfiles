let g:NERDTreeMinimalUI = 0
let g:NERDTreeShowHidden = 1
let g:NERDTreeShowLineNumbers = 0
let g:NERDTreeCascadeSingleChildDir = 1
let g:NERDTreeDirArrowExpandable = "•"
let g:NERDTreeDirArrowCollapsible = "•"
let g:NERDTreeWinSize = 31
let NERDTreeIgnore=['\.pyc$', '\.pyo$', '__pycache__$']

" Preview in fzf
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', 'highlight --out-format=ansi {}']}, <bang>0)


autocmd VimLeave *.tex !texclear %

autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
autocmd BufRead,BufNewFile *.tex set filetype=tex

autocmd BufWritePost bm-files,bm-dirs !shortcuts
autocmd BufRead,BufNewFile xresources,xdefaults set filetype=xdefaults

let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1

let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
let g:tex_conceal='abdmg'
