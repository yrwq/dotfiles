map <C-n> :NERDTreeToggle<CR>

map <Tab> :noh<CR>
map <C-f> :Files<CR>

" Move lines
nnoremap <C-A-j> :m .+1<CR>==
nnoremap <C-A-k> :m .-2<CR>==

" Open current file with corresponding program
map <C-o> :!opout <c-r>%<CR><CR>

" Write as sudo
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Compile
map <C-c> :w! \| !compile "<c-r>%"<CR>

" Toggle tag bar
map <leader>s :TagbarToggle<CR>

" Shortcut navigations
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Lf file manager
map <leader>d :LfCurrentFile <CR>

map <leader>l :> <CR>
map <leader>h :< <CR>
map <leader>p :Snippets <CR>

map <leader>t :badd .<CR>
map <leader>w :Bclose<CR>
map <leader>q :bprevious<CR>
map <leader>e :bnext<CR>
