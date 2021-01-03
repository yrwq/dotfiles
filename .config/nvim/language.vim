" Lanuage options
function! SetLuaOptions()
  :call tagbar#autoopen(0)
  let lua_highlight_functions = 1
  let lua_highlight_all = 1
endfunction

function! SetJavaOptions()
  :call tagbar#autoopen(0)
  let java_highlight_functions = 1
  let java_highlight_all = 1
endfunction

function! SetRustOptions()
  :call tagbar#autoopen(0)
  let rust_highlight_functions = 1
  let rust_highlight_all = 1
endfunction

function! SetShOptions()
  :call tagbar#autoopen(0)
  let sh_highlight_functions = 1
  let sh_highlight_all = 1
endfunction

function! SetCOptions()
  :call tagbar#autoopen(0)
  let c_highlight_functions = 1
  let c_highlight_all = 1
endfunction

" Load options when given file opened
autocmd FileType lua call SetLuaOptions()
autocmd FileType java call SetJavaOptions()
autocmd FileType rust call SetRustOptions()
autocmd FileType sh call SetShOptions()
autocmd FileType c call SetCOptions()
