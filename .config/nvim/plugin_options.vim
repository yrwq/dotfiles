let g:NERDTreeMinimalUI = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeShowLineNumbers = 0
let g:NERDTreeCascadeSingleChildDir = 0
let g:NERDTreeDirArrowExpandable = "•"
let g:NERDTreeDirArrowCollapsible = "•"
let g:NERDTreeWinSize = 31
map <C-n> :NERDTreeToggle<CR>

" let g:ale_lint_on_text_changed = 'never'
" let g:ale_lint_on_enter = 0
" let g:ale_linters = {
" \   'javascript': ['jshint'],
" \   'python': ['flake8']
" \}

let g:gitgutter_enabled=1

let g:dashboard_default_executive ='fzf'
let g:dashboard_default_header = "commicgirl9"

" Preview in fzf
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', 'highlight --out-format=ansi {}']}, <bang>0)


autocmd VimLeave *.tex !texclear %

autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
autocmd BufRead,BufNewFile *.tex set filetype=tex


autocmd BufWritePost bm-files,bm-dirs !shortcuts
autocmd BufRead,BufNewFile xresources,xdefaults set filetype=xdefaults

" let g:ycm_key_list_select_completion = ['<C-j>', '<Down>']
" let g:ycm_key_list_previous_completion = ['<C-k>', '<Up>']
