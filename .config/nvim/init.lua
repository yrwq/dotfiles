-- set the leader to space
vim.g.mapleader = ' '

local fn = vim.fn
local execute = vim.api.nvim_command

require("settings")

-- bootstrap packer.nvim
local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

require("plugins")

vim.cmd[[
nnoremap <silent> <A-d> :Lspsaga open_floaterm<CR>
tnoremap <silent> <A-d> <C-\><C-n>:Lspsaga close_floaterm<CR>
]]

local nmap = {
    ["ca"]          = "<cmd>Lspsaga code_action<CR>",
    ['K']           = "<cmd>Lspsaga hover_doc<CR>",
    ["C-f"]         = "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>",
    ["C-b"]         = "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>",
    ["<leader>s"]   = "<cmd>Lspsaga show_line_diagnostics<CR>",
    ["<leader>e"]   = "<cmd>Lspsaga diagnostic_jump_next<CR>",
    ["<leader>E"]   = "<cmd>Lspsaga diagnostic_jump_prev<CR>",
    ["<Tab>"]       = "<cmd>noh<CR>",
}

local imap = {
    ['<C-h>']       = "<ESC>",
    ['<C-j>']       = "<ESC>",
    ['<C-k>']       = "<ESC>",
    ['<C-l>']       = "<ESC>",
}

local vmap = {}
local cmap = {}

local default_args = { noremap = true }

for mode, map in pairs({ 
    n = nmap,
    v = vmap,
    t = tmap,
    c = cmap,
    i = imap
}) do
    for from, to in pairs(map) do
        if type(to) == 'table' then
            vim.api.nvim_set_keymap(mode, from, to[1], to[2])
        else
            vim.api.nvim_set_keymap(mode, from, to, default_args)
        end
    end
end
