nnoremap <silent> <Leader>fh :DashboardFindHistory<CR>
nnoremap <silent> <Leader>ff :DashboardFindFile<CR>
nnoremap <silent> <Leader>tc :DashboardChangeColorscheme<CR>
nnoremap <silent> <Leader>fa :DashboardFindWord<CR>
nnoremap <silent> <Leader>fb :DashboardJumpMark<CR>
nnoremap <silent> <Leader>cn :DashboardNewFile<CR>
inoremap <expr><S-TAB> pumvisible() ? "\<Esc>" : "\<C-n>"
map <Tab> :noh<CR>
map <C-f> :Files<CR>

" Move lines
nnoremap <C-A-j> :m .+1<CR>==
nnoremap <C-A-k> :m .-2<CR>==

" Open current file with given application
map <C-o> :!opout <c-r>%<CR><CR>

" Write as sudo
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Compile
map <C-c> :w! \| !compile "<c-r>%"<CR>

" Manage tabs
map <leader>t :tabnew<CR>
map <leader>w :tabclose<CR>
map <leader>q :tabprev<CR>
map <leader>e :tabnext<CR>

" Toggle tag bar
nnoremap <leader>f :TagbarToggle<CR>

" Shortcut navigations
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Lf file manager
map <leader>d :LfCurrentFile <CR>
