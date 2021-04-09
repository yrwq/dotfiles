local cmd = vim.cmd
local o = vim.o
local g = vim.g
local w = vim.wo
local b = vim.bo

local indent = 4

cmd "syntax enable"
cmd "filetype plugin indent on"


cmd "colorscheme cool"
-- cmd "colorscheme kory"
-- cmd "colorscheme dear"
-- cmd "colorscheme tlou2"

-- global
o.hidden = true             -- keep multiple buffers open
o.pumheight = 10            -- make popup menu smaller
o.fileencoding = "utf-8"    -- the encoding written to file
o.termguicolors = true      -- better colors
o.t_Co = "256"              -- support 256 colors
o.conceallevel = 0          -- so i can see ``` in markdown files
o.scrolloff = indent * 2    -- give more space when scrolling
o.showmode = false          -- disable -- INSERT -- and things like that
o.backup = false            -- disable backing up
o.writebackup = false       -- disable backing up
o.clipboard = "unnamedplus" -- set clipboard to system clipboard
o.ignorecase = true         -- ignore case sensitivity
o.formatoptions = ""        -- disable autocommenting on new line
o.undofile = true           -- enable undo file
o.swapfile = false          -- don't create swap files


-- buffer specific
b.tabstop = indent          -- insert 4 spaces for tab
b.shiftwidth = indent       -- change number of spaces instead of indentation
b.softtabstop = indent      -- number of spaces that a tab counts
b.expandtab = true          -- use spaces instead of tabs
b.smartindent = true        -- better indenting
b.autoread = true           -- automatically read files when changed outside of vim

-- window specific
w.number = true             -- enable line numbers
w.signcolumn = "yes"        -- always show sign column

-- plugin settings
g.indentLine_char = "▏"     -- indentline's character
g.Hexokinase_highlighters = { "virtual" }
-- g.Hexokinase_highlighters = { "sign_column" }
g.Hexokinase_v2 = 1
g.Hexokinase_virtualText = ' '
g.Hexokinase_signIcon = ' '
g.gruvbox_contrast_dark = 'soft'
g.gruvbox_contrast_light = 'soft'
