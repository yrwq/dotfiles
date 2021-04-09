local lspc = require("lspconfig")

local servers = {
    "clangd",           -- sudo pacman -Sy clangd
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

-- setup lua lsp
local sumneko_root_path = os.getenv("HOME") .. 
    "/etc/repos/lua-language-server"

local sumneko_binary = sumneko_root_path .. "/bin/Linux/lua-language-server"

lspc.sumneko_lua.setup {
    cmd = {
        sumneko_binary, "-E",
        sumneko_root_path .. "/main.lua"
    };
    settings = {
        Lua = {
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {
                    "vim",
                    "use", -- packer's use
                    -- awesome wm
                    "awesome",
                    "screen",
                    "client",
                    "root"
                },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                    ["/usr/share/awesome/lib"] = true
                },
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}
