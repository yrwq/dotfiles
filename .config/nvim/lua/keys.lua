local keymap = require("utils.keymap")

-- Little helper functions to execute commands from insert mode
local function cmd(command) return "<cmd>"..command.."<CR>" end
local function norm(command) return cmd("normal! "..command) end

keymap.normal["ca"] 	    = cmd "Lspsaga code_action"
keymap.normal["K"]	        = cmd "Lspsaga hover_doc"
keymap.normal["<leader>s"]  = cmd "Lspsaga show_line_diagnostics"
keymap.normal["<Tab>"]      = cmd "noh"

vim.cmd[[
nnoremap <silent> <A-d> :Lspsaga open_floaterm<CR>
tnoremap <silent> <A-d> <C-\><C-n>:Lspsaga close_floaterm<CR>
]]
