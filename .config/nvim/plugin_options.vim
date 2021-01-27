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

" let bufferline = {}
" let bufferline.animation = v:true
" let bufferline.auto_hide = v:false
" let bufferline.icons = v:true

" let bufferline.icon_separator_active = ''
" let bufferline.icon_separator_inactive = ''
" let bufferline.icon_close_tab = ''
" let bufferline.icon_close_tab_modified = '●'

" let bufferline.closable = v:true
" let bufferline.clickable = v:true
" let bufferline.semantic_letters = v:true

" let bufferline.letters =
"   \ 'asdfjklqweruio'

" let bufferline.maximum_padding = 8

lua << EOF
require'bufferline'.setup{
  options = {
    view = "multiwindow",
    mappings = true,
    buffer_close_icon= '',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    max_name_length = 18,
    max_prefix_length = 15,
    tab_size = 18,
    show_buffer_close_icons = true,
    separator_style = "thin",
    enforce_regular_tabs = true,
    always_show_bufferline = true,
  }
}
EOF
