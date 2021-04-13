local lspc = require("lspconfig")

local servers = {

    -- sudo pacman -Sy clangd
    "clangd",

    -- pip install pynvim neovim 'python-language-server[all]'
    -- npm i -g pyright
    "pyright", 

    -- GO111MODULE=on go get golang.org/x/tools/gopls@latest
    "gopls"
}

for _, lsp in ipairs(servers) do
    lspc[lsp].setup { on_attach = on_attach }
end

-- disable inline diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false
    }
)
