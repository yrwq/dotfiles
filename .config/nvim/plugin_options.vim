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


"
" Coc
"
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" " Use <c-space> to trigger completion.
" if has('nvim')
"   inoremap <silent><expr> <c-space> coc#refresh()
" else
"   inoremap <silent><expr> <c-@> coc#refresh()
" endif

" " Make <CR> auto-select the first completion item and notify coc.nvim to
" " format on enter, <cr> could be remapped by other vim plugin
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
"                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" " Use K to show documentation in preview window.
" nnoremap <silent> K :call <SID>show_documentation()<CR>

" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   elseif (coc#rpc#ready())
"     call CocActionAsync('doHover')
"   else
"     execute '!' . &keywordprg . " " . expand('<cword>')
"   endif
" endfunction

" " Highlight the symbol and its references when holding the cursor.
" autocmd CursorHold * silent call CocActionAsync('highlight')

" let g:coc_global_extensions = ["coc-json",
"     \ "coc-ultisnips",
"     \ "coc-python"]
"
