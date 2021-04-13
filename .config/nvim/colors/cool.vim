scriptencoding utf-8

set background=dark

if v:version > 580
  hi clear
  if exists('syntax_on')
    syntax reset
  endif
endif

let g:colors_name='cool'

if !has('gui_running') && &t_Co != 256
  finish
endif

let s:black          = ['#201e1a', 0]
let s:red            = ['#6d413b', 1]
let s:green          = ['#6a7253', 2]
let s:yellow         = ['#7e5d3c', 3]
let s:blue           = ['#527272', 4]
let s:magenta        = ['#6c4949', 5]
let s:cyan           = ['#4f5c5c', 6]
let s:white          = ['#867564', 7]
let s:bright_black   = ['#322b28', 8]
let s:bright_red     = ['#5e4643', 9]
let s:bright_green   = ['#484a41', 10]
let s:bright_yellow  = ['#6b5a48', 11]
let s:bright_blue    = ['#535a5a', 12]
let s:bright_magenta = ['#4f4141', 13]
let s:bright_cyan    = ['#515c5c', 14]
let s:bright_white   = ['#947e68', 15]

" xterm colors.
let s:orange        = ['#84603C', 202]
let s:bright_orange = ['#84603C', 208]
let s:hard_black    = ['#121212', 233]
let s:xgray1        = ['#262626', 235]
let s:xgray2        = ['#272520', 236]
let s:xgray3        = ['#3A3A3A', 237]
let s:xgray4        = ['#444444', 238]
let s:xgray5        = ['#443a36', 239]
let s:xgray6        = ['#585858', 240]

let s:none = ['NONE', 'NONE']

if !exists('g:cool_bold')
  let g:cool_bold=1
endif

if !exists('g:cool_italic')
  if has('gui_running') || $TERM_ITALICS ==? 'true'
    let g:cool_italic=1
  else
    let g:cool_italic=0
  endif
endif

if !exists('g:cool_transparent_background')
  let g:cool_transparent_background=0
endif

if !exists('g:cool_undercurl')
  let g:cool_undercurl=1
endif

if !exists('g:cool_underline')
  let g:cool_underline=1
endif

if !exists('g:cool_inverse')
  let g:cool_inverse=1
endif

if !exists('g:cool_inverse_matches')
  let g:cool_inverse_matches=0
endif

if !exists('g:cool_inverse_match_paren')
  let g:cool_inverse_match_paren=0
endif

if !exists('g:cool_dim_lisp_paren')
  let g:cool_dim_lisp_paren=0
endif

let g:cool_guisp_fallback='NONE'

let s:bold = 'bold,'
if g:cool_bold == 0
  let s:bold = ''
endif

let s:italic = 'italic,'
if g:cool_italic == 0
  let s:italic = ''
endif

let s:underline = 'underline,'
if g:cool_underline == 0
  let s:underline = ''
endif

let s:undercurl = 'undercurl,'
if g:cool_undercurl == 0
  let s:undercurl = ''
endif

let s:inverse = 'inverse,'
if g:cool_inverse == 0
  let s:inverse = ''
endif

" }}}
" Highlighting Function: {{{

function! s:HL(group, fg, ...)
  " Arguments: group, guifg, guibg, gui, guisp

  " foreground
  let l:fg = a:fg

  " background
  if a:0 >= 1
    let l:bg = a:1
  else
    let l:bg = s:none
  endif

  " emphasis
  if a:0 >= 2 && strlen(a:2)
    let l:emstr = a:2
  else
    let l:emstr = 'NONE,'
  endif

  " special fallback
  if a:0 >= 3
    if g:cool_guisp_fallback !=# 'NONE'
      let fg = a:3
    endif

    " bg fallback mode should invert higlighting
    if g:cool_guisp_fallback ==# 'bg'
      let emstr .= 'inverse,'
    endif
  endif

  let l:histring = [ 'hi', a:group,
        \ 'guifg=' . l:fg[0], 'ctermfg=' . l:fg[1],
        \ 'guibg=' . l:bg[0], 'ctermbg=' . l:bg[1],
        \ 'gui=' . l:emstr[:-2], 'cterm=' . l:emstr[:-2]
        \ ]

  " special
  if a:0 >= 3
    call add(l:histring, 'guisp=' . a:3[0])
  endif

  execute join(l:histring, ' ')
endfunction

" memoize common hi groups
call s:HL('Tlou2White', s:white)
call s:HL('Tlou2Red', s:red)
call s:HL('Tlou2Green', s:green)
call s:HL('Tlou2Yellow', s:yellow)
call s:HL('Tlou2Blue', s:blue)
call s:HL('Tlou2Magenta', s:magenta)
call s:HL('Tlou2Cyan', s:cyan)
call s:HL('Tlou2Black', s:black)

call s:HL('Tlou2RedBold', s:red, s:none, s:bold)
call s:HL('Tlou2GreenBold', s:green, s:none, s:bold)
call s:HL('Tlou2YellowBold', s:yellow, s:none, s:bold)
call s:HL('Tlou2BlueBold', s:blue, s:none, s:bold)
call s:HL('Tlou2MagentaBold', s:magenta, s:none, s:bold)
call s:HL('Tlou2CyanBold', s:cyan, s:none, s:bold)

call s:HL('Tlou2BrightRed', s:bright_red, s:none)
call s:HL('Tlou2BrightGreen', s:bright_green, s:none)
call s:HL('Tlou2BrightYellow', s:bright_yellow, s:none)
call s:HL('Tlou2BrightBlue', s:bright_blue, s:none)
call s:HL('Tlou2BrightMagenta', s:bright_magenta, s:none)
call s:HL('Tlou2BrightCyan', s:bright_cyan, s:none)
call s:HL('Tlou2BrightBlack', s:bright_black, s:none)
call s:HL('Tlou2BrightWhite', s:bright_white)

" special
call s:HL('Tlou2Orange', s:orange)
call s:HL('Tlou2BrightOrange', s:bright_orange)
call s:HL('Tlou2OrangeBold', s:orange, s:none, s:bold)
call s:HL('Tlou2HardBlack', s:hard_black)
call s:HL('Tlou2Xgray1', s:xgray1)
call s:HL('Tlou2Xgray2', s:xgray2)
call s:HL('Tlou2Xgray3', s:xgray3)
call s:HL('Tlou2Xgray4', s:xgray4)
call s:HL('Tlou2Xgray5', s:xgray5)
call s:HL('Tlou2Xgray6', s:xgray6)

" }}}
" Setup Terminal Colors For Neovim: {{{

if has('nvim')
  let g:terminal_color_0 = s:black[0]
  let g:terminal_color_8 = s:bright_black[0]

  let g:terminal_color_1 = s:red[0]
  let g:terminal_color_9 = s:bright_red[0]

  let g:terminal_color_2 = s:green[0]
  let g:terminal_color_10 = s:bright_green[0]

  let g:terminal_color_3 = s:yellow[0]
  let g:terminal_color_11 = s:bright_yellow[0]

  let g:terminal_color_4 = s:blue[0]
  let g:terminal_color_12 = s:bright_blue[0]

  let g:terminal_color_5 = s:magenta[0]
  let g:terminal_color_13 = s:bright_magenta[0]

  let g:terminal_color_6 = s:cyan[0]
  let g:terminal_color_14 = s:bright_cyan[0]

  let g:terminal_color_7 = s:white[0]
  let g:terminal_color_15 = s:bright_white[0]
endif

" }}}
" Setup Terminal Colors For Vim with termguicolors: {{{

if exists('*term_setansicolors')
  let g:terminal_ansi_colors = repeat([0], 16)

  let g:terminal_ansi_colors[0] = s:black[0]
  let g:terminal_ansi_colors[8] = s:bright_black[0]

  let g:terminal_ansi_colors[1] = s:red[0]
  let g:terminal_ansi_colors[9] = s:bright_red[0]

  let g:terminal_ansi_colors[2] = s:green[0]
  let g:terminal_ansi_colors[10] = s:bright_green[0]

  let g:terminal_ansi_colors[3] = s:yellow[0]
  let g:terminal_ansi_colors[11] = s:bright_yellow[0]

  let g:terminal_ansi_colors[4] = s:blue[0]
  let g:terminal_ansi_colors[12] = s:bright_blue[0]

  let g:terminal_ansi_colors[5] = s:magenta[0]
  let g:terminal_ansi_colors[13] = s:bright_magenta[0]

  let g:terminal_ansi_colors[6] = s:cyan[0]
  let g:terminal_ansi_colors[14] = s:bright_cyan[0]

  let g:terminal_ansi_colors[7] = s:white[0]
  let g:terminal_ansi_colors[15] = s:bright_white[0]
endif

" Normal text
"
"
"
call s:HL('Normal', s:bright_white, s:black)

call s:HL('CursorLine',   s:none, s:xgray2)
hi! link CursorColumn CursorLine
call s:HL('TabLineFill', s:bright_black, s:xgray2)
call s:HL('TabLineSel', s:bright_white, s:xgray5)
hi! link TabLine TabLineFill

"call s:HL('MatchParen', s:bright_magenta, s:none, s:inverse . s:bold)
call s:HL('MatchParen', s:magenta, s:none, s:bold)

" hi rainbowcol1 guifg=#123456

call s:HL('ColorColumn',  s:none, s:xgray6)
call s:HL('Conceal', s:blue, s:none)
call s:HL('CursorLineNr', s:bright_black, s:black)

hi! link NonText Tlou2Red
hi! link SpecialKey Tlou2Blue

call s:HL('Visual', s:none, s:bright_black, s:bold)

hi! link VisualNOS Visual

call s:HL('Search', s:none, s:bright_black, s:bold)
call s:HL('IncSearch', s:none, s:bright_black, s:underline . s:bold)

call s:HL('Underlined', s:blue, s:none, s:underline)

call s:HL('StatusLine',   s:black, s:bright_black)

call s:HL('StatusLineNC', s:black, s:black)
call s:HL('VertSplit', s:bright_black, s:black)
call s:HL('WildMenu', s:black, s:white, s:bold)

hi! link Directory Tlou2GreenBold
hi! link Title Tlou2GreenBold

call s:HL('ErrorMsg', s:bright_white, s:red)
hi! link MoreMsg Tlou2YellowBold
hi! link ModeMsg Tlou2YellowBold
hi! link Question Tlou2OrangeBold
hi! link WarningMsg Tlou2RedBold

call s:HL('LineNr', s:xgray3)

call s:HL('SignColumn', s:none, s:black)
call s:HL('Folded', s:bright_black, s:black, s:italic)
call s:HL('FoldColumn', s:bright_black, s:black)

call s:HL('Cursor', s:bright_black, s:bright_black)
hi! link vCursor Cursor
hi! link iCursor Cursor
hi! link lCursor Cursor

hi! link Special Tlou2Magenta

call s:HL('Comment', s:xgray4, s:none, s:italic)
call s:HL('Error', s:bright_white, s:red, s:bold)

call s:HL('String',  s:green)

hi! link Statement Tlou2Red
hi! link Conditional Tlou2Red
hi! link Repeat Tlou2Red
hi! link Label Tlou2Red
hi! link Exception Tlou2Red
hi! link Operator Normal
hi! link Keyword Tlou2Red

hi! link Identifier Tlou2Cyan
hi! link Function Tlou2Yellow

hi! link PreProc Tlou2Cyan
hi! link Include Tlou2Cyan
hi! link Define Tlou2Cyan
hi! link Macro Tlou2Orange
hi! link PreCondit Tlou2Cyan

hi! link Constant Tlou2BrightMagenta
hi! link Character Tlou2BrightMagenta
hi! link Boolean Tlou2BrightMagenta
hi! link Number Tlou2BrightMagenta
hi! link Float Tlou2BrightMagenta

call s:HL('Type', s:yellow, s:none, s:italic)

hi! link StorageClass Tlou2Orange
hi! link Structure Tlou2Cyan
hi! link Typedef Tlou2Magenta
hi! link Delimiter Tlou2BrightYellow

call s:HL('Pmenu', s:white, s:bright_black)
call s:HL('PmenuSel', s:black, s:white, s:bold)
call s:HL('PmenuSbar', s:none, s:black)
call s:HL('PmenuThumb', s:none, s:black)

hi! link LspDiagnosticsDefaultError Tlou2BrightRed
hi! link LspDiagnosticsDefaultWarning Tlou2BrightYellow
hi! link LspDiagnosticsDefaultInformation Tlou2BrightGreen
hi! link LspDiagnosticsDefaultHint Tlou2BrightCyan
call s:HL('LspDiagnosticsUnderlineError', s:bright_red, s:none, s:underline)
call s:HL('LspDiagnosticsUnderlineWarning', s:bright_yellow, s:none, s:underline)
call s:HL('LspDiagnosticsUnderlineInformation', s:bright_green, s:none, s:underline)
call s:HL('LspDiagnosticsUnderlineHint', s:bright_cyan, s:none, s:underline)

" }}}

" Plugin specific -------------------------------------------------------------
" Sneak: {{{

hi! link Sneak Search
call s:HL('SneakScope', s:none, s:hard_black)
hi! link SneakLabel Search

call s:HL('IndentGuidesEven', s:none, s:xgray3)
call s:HL('IndentGuidesOdd',  s:none, s:xgray4)

hi! link CocErrorSign Tlou2Red
hi! link CocWarningSign Tlou2BrightOrange
hi! link CocInfoSign Tlou2Yellow
hi! link CocHintSign Tlou2Blue
hi! link CocErrorFloat Tlou2Red
hi! link CocWarningFloat Tlou2Orange
hi! link CocInfoFloat Tlou2Yellow
hi! link CocHintFloat Tlou2Blue
hi! link CocDiagnosticsError Tlou2Red
hi! link CocDiagnosticsWarning Tlou2Orange
hi! link CocDiagnosticsInfo Tlou2Yellow
hi! link CocDiagnosticsHint Tlou2Blue

hi! link CocSelectedText Tlou2Red
hi! link CocCodeLens Tlou2White

call s:HL('CocErrorHighlight', s:none, s:none, s:undercurl, s:red)
call s:HL('CocWarningHighlight', s:none, s:none, s:undercurl, s:bright_orange)
call s:HL('CocInfoHighlight', s:none, s:none, s:undercurl, s:yellow)
call s:HL('CocHintHighlight', s:none, s:none, s:undercurl, s:blue)

hi! link htmlTag Tlou2Blue
hi! link htmlEndTag Tlou2Blue

hi! link htmlTagName Tlou2Blue
hi! link htmlTag Tlou2BrightBlack
hi! link htmlArg Tlou2Yellow

hi! link htmlScriptTag Tlou2Red
hi! link htmlTagN Tlou2Blue
hi! link htmlSpecialTagName Tlou2Blue

call s:HL('htmlLink', s:bright_white, s:none, s:underline)

hi! link htmlSpecialChar Tlou2Yellow

call s:HL('htmlBold', s:bright_white, s:black, s:bold)
call s:HL('htmlBoldUnderline', s:bright_white, s:black, s:bold . s:underline)
call s:HL('htmlBoldItalic', s:bright_white, s:black, s:bold . s:italic)
call s:HL('htmlBoldUnderlineItalic', s:bright_white, s:black, s:bold . s:underline . s:italic)
call s:HL('htmlUnderline', s:bright_white, s:black, s:underline)
call s:HL('htmlUnderlineItalic', s:bright_white, s:black, s:underline . s:italic)
call s:HL('htmlItalic', s:bright_white, s:black, s:italic)

call s:HL('vimCommentTitle', s:bright_white, s:none, s:bold . s:italic)

hi! link vimNotation Tlou2Yellow
hi! link vimBracket Tlou2Yellow
hi! link vimMapModKey Tlou2Yellow
hi! link vimFuncSID Tlou2BrightWhite
hi! link vimSetSep Tlou2BrightWhite
hi! link vimSep Tlou2BrightWhite
hi! link vimContinue Tlou2BrightWhite

hi! link cOperator Tlou2Magenta
hi! link cStructure Tlou2Yellow

hi! link pythonBuiltin Tlou2Yellow
hi! link pythonBuiltinObj Tlou2Yellow
hi! link pythonBuiltinFunc Tlou2Yellow
hi! link pythonFunction Tlou2Cyan
hi! link pythonDecorator Tlou2Red
hi! link pythonInclude Tlou2Blue
hi! link pythonImport Tlou2Blue
hi! link pythonRun Tlou2Blue
hi! link pythonCoding Tlou2Blue
hi! link pythonOperator Tlou2Red
hi! link pythonExceptions Tlou2Magenta
hi! link pythonBoolean Tlou2Magenta
hi! link pythonDot Tlou2BrightWhite

hi! link cssBraces Tlou2BrightWhite
hi! link cssFunctionName Tlou2Yellow
hi! link cssIdentifier Tlou2Blue
hi! link cssClassName Tlou2Blue
hi! link cssClassNameDot Tlou2Blue
hi! link cssColor Tlou2BrightMagenta
hi! link cssSelectorOp Tlou2Blue
hi! link cssSelectorOp2 Tlou2Blue
hi! link cssImportant Tlou2Green
hi! link cssVendor Tlou2Blue
hi! link cssMediaProp Tlou2Yellow
hi! link cssBorderProp Tlou2Yellow
hi! link cssAttrComma Tlou2BrightWhite

hi! link cssTextProp Tlou2Yellow
hi! link cssAnimationProp Tlou2Yellow
hi! link cssUIProp Tlou2Yellow
hi! link cssTransformProp Tlou2Yellow
hi! link cssTransitionProp Tlou2Yellow
hi! link cssPrintProp Tlou2Yellow
hi! link cssPositioningProp Tlou2Yellow
hi! link cssBoxProp Tlou2Yellow
hi! link cssFontDescriptorProp Tlou2Yellow
hi! link cssFlexibleBoxProp Tlou2Yellow
hi! link cssBorderOutlineProp Tlou2Yellow
hi! link cssBackgroundProp Tlou2Yellow
hi! link cssMarginProp Tlou2Yellow
hi! link cssListProp Tlou2Yellow
hi! link cssTableProp Tlou2Yellow
hi! link cssFontProp Tlou2Yellow
hi! link cssPaddingProp Tlou2Yellow
hi! link cssDimensionProp Tlou2Yellow
hi! link cssRenderProp Tlou2Yellow
hi! link cssColorProp Tlou2Yellow
hi! link cssGeneratedContentProp Tlou2Yellow
hi! link cssTagName Tlou2BrightBlue

hi! link sassClass Tlou2Blue
hi! link sassClassChar Tlou2Blue
hi! link sassVariable Tlou2Cyan
hi! link sassIdChar Tlou2BrightBlue


hi! link javaScriptMember Tlou2Blue
hi! link javaScriptNull Tlou2Magenta

hi! link javascriptParens Tlou2BrightCyan
hi! link javascriptFuncArg Normal
hi! link javascriptDocComment Tlou2Green
hi! link javascriptArrayMethod Function
hi! link javascriptReflectMethod Function
hi! link javascriptStringMethod Function
hi! link javascriptObjectMethod Function
hi! link javascriptObjectStaticMethod Function
hi! link javascriptObjectLabel Tlou2Blue

hi! link javascriptProp Tlou2Blue

hi! link javascriptVariable Tlou2BrightBlue
hi! link javascriptOperator Tlou2BrightCyan
hi! link javascriptFuncKeyword Tlou2BrightRed
hi! link javascriptFunctionMethod Tlou2Yellow
hi! link javascriptReturn Tlou2BrightRed
hi! link javascriptEndColons Normal

hi! link rubyStringDelimiter Tlou2Green
hi! link rubyInterpolationDelimiter Tlou2Cyan
hi! link rubyDefine Keyword

hi! link objcTypeModifier Tlou2Red
hi! link objcDirective Tlou2Blue

hi! link goDirective Tlou2Cyan
hi! link goConstants Tlou2Magenta
hi! link goDeclaration Tlou2Red
hi! link goDeclType Tlou2Blue
hi! link goBuiltins Tlou2Yellow

hi! link luaIn Tlou2Red
hi! link luaFunction Tlou2Cyan
hi! link luaTable Tlou2Yellow

call s:HL('markdownItalic', s:bright_white, s:none, s:italic)

hi! link markdownH1 Tlou2GreenBold
hi! link markdownH2 Tlou2GreenBold
hi! link markdownH3 Tlou2YellowBold
hi! link markdownH4 Tlou2YellowBold
hi! link markdownH5 Tlou2Yellow
hi! link markdownH6 Tlou2Yellow

hi! link markdownCode Tlou2Cyan
hi! link markdownCodeBlock Tlou2Cyan
hi! link markdownCodeDelimiter Tlou2Cyan

hi! link markdownUrlDelimiter Tlou2BrightWhite
hi! link markdownLinkDelimiter Tlou2BrightWhite
hi! link markdownLinkTextDelimiter Tlou2BrightWhite

hi! link markdownHeadingDelimiter Tlou2Yellow
hi! link markdownUrl Tlou2Magenta
hi! link markdownUrlTitleDelimiter Tlou2Green

call s:HL('markdownLinkText', s:bright_black, s:none, s:underline)
hi! link markdownIdDeclaration markdownLinkText

hi! link haskellType Tlou2Blue
hi! link haskellIdentifier Tlou2Blue
hi! link haskellSeparator Tlou2Blue
hi! link haskellDelimiter Tlou2BrightWhite
hi! link haskellOperators Tlou2Blue

hi! link haskellBacktick Tlou2Yellow
hi! link haskellStatement Tlou2Yellow
hi! link haskellConditional Tlou2Yellow

hi! link haskellLet Tlou2Cyan
hi! link haskellDefault Tlou2Cyan
hi! link haskellWhere Tlou2Cyan
hi! link haskellBottom Tlou2Cyan
hi! link haskellBlockKeywords Tlou2Cyan
hi! link haskellImportKeywords Tlou2Cyan
hi! link haskellDeclKeyword Tlou2Cyan
hi! link haskellDeriving Tlou2Cyan
hi! link haskellAssocType Tlou2Cyan

hi! link haskellNumber Tlou2Magenta
hi! link haskellPragma Tlou2Magenta

hi! link haskellString Tlou2Green
hi! link haskellChar Tlou2Green

hi! link jsonKeyword Tlou2Green
hi! link jsonQuote Tlou2Green
hi! link jsonBraces Tlou2Blue
hi! link jsonString Tlou2Blue

hi! link rustCommentLineDoc Tlou2Green
hi! link rustModPathSep Tlou2BrightBlack

hi! link makePreCondit Tlou2Red
hi! link makeCommands Tlou2BrightWhite
hi! link makeTarget Tlou2Yellow

call s:HL('shParenError', s:bright_white, s:bright_red)
call s:HL('ExtraWhitespace', s:none, s:red)

call s:HL('rainbowcol1', s:magenta)
call s:HL('rainbowcol2', s:yellow)
call s:HL('rainbowcol3', s:green)
call s:HL('rainbowcol4', s:red)
call s:HL('rainbowcol5', s:blue)
call s:HL('rainbowcol6', s:cyan)
call s:HL('rainbowcol7', s:white)

call s:HL("Todos", s:red, s:bright_black, s:bold)
match Todos "\(TODO:\|FIXME:\)"
