local lspc = require("lspconfig")

local servers = {
    "clangd",           -- sudo pacman -Sy clangd

    -- curl -L https://github.com/rust-analyzer/rust-analyzer/releases/latest/download/rust-analyzer-linux -o ~/.local/bin/rust-analyzer
    -- chmod +x ~/.local/bin/rust-analyzer
    "rust_analyzer",

    -- pip install pynvim neovim 'python-language-server[all]'
    -- npm i -g pyright
    "pyright", 
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
