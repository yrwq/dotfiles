vim.cmd 'packadd cfilter'
vim.cmd 'packadd packer.nvim'

local init = function ()
    use {'wbthomason/packer.nvim', opt = true}

    use "tpope/vim-surround"            -- '" :()
    use "tpope/vim-commentary"          -- comments go br
    use "yggdroot/indentline"           -- indent lines

    use {
        "RRethy/vim-hexokinase",
        run = "make hexokinase"
    }

    -- tree sitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
        requires = {
            "p00f/nvim-ts-rainbow",
        },
        config = function()
            require("cool.tree_sitter")
        end
    }

    -- lsp stuff
    use {
        "neovim/nvim-lspconfig",
        config = function()
            require("cool.lsp_config")
        end
    }

    
    use {
        "glepnir/lspsaga.nvim",
        config = function()
            require("cool.lsp_saga")
        end
    }

end

return require('packer').startup(init)
