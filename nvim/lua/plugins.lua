-- $Id lua/plugins.lua
--
local fn = vim.fn
local execute = vim.api.nvim_command
local gvars = require('globalvariables')

local install_path = gvars.packer_start_path .. '/packer.nvim'
-- Auto install packer.nvim if not exists
if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
    execute([[packadd packer.nvim]])  -- Load packer if it is installed in opt
end

vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' -- Auto compile when there are changes in plugins.lua

return require('packer').startup(function(use)

    -- Packer can manage itself as an optional plugin
    use {'wbthomason/packer.nvim'}

    -- Color scheme
    use {'kyazdani42/nvim-web-devicons',
        config = function() require 'config.devicons' end
    }

	use {'tanvirtin/monokai.nvim'}
	--[[
    use {
        'npxbr/gruvbox.nvim",
        requires = {'rktjmp/lush.nvim'}
    }
    ]]
    use {'sainnhe/gruvbox-material'}
    use {'joshdick/onedark.vim'}

    -- Development
    use {'nvim-lua/plenary.nvim'}
    use {'nvim-lua/popup.nvim'}
    use {'norcalli/nvim-colorizer.lua',
        config = function() require 'config.colorizer' end
    }
    use {'windwp/nvim-autopairs',
        config = function() require 'config.autopairs' end
    }

    -- Testing

    -- Snippets
    -- use {'hrsh7th/vim-vsnip'}
    -- use {'cstrap/python-snippets'}
    -- use {'ylcnfrht/vscode-python-snippet-pack'}
    -- use {'xabikos/vscode-javascript'}
    -- use { 'nvim-telescope/telescope-snippets.nvim' }

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.5',
        lazy = true,
        requires = { {'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}, { "nvim-telescope/telescope-live-grep-args.nvim" }, },
        config = function()
            require("telescope").load_extension("live_grep_args")
        end
        --config = function() require 'config.telescope' end
    }
    use {'nvim-telescope/telescope-symbols.nvim'}
    use {'nvim-telescope/telescope-media-files.nvim'}
    use {'nvim-telescope/telescope-packer.nvim'}
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
    use {"nvim-telescope/telescope-file-browser.nvim",
        requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    }

    if jit.os ~= 'Windows' then
        -- LSP config
        --use {'neovim/nvim-lspconfig', config = function() require 'lsp' end }
        --use {'kabouzeid/nvim-lspinstall'}
        --use {'glepnir/lspsaga.nvim'}
        --use {'hrsh7th/nvim-compe', config = function() require 'config.compe' end }

        -- Teesitter
        use {'nvim-treesitter/nvim-treesitter',
            run = function()
                local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
                ts_update()
            end,
        }
        use {'windwp/nvim-ts-autotag'}
        use {'nvim-treesitter/playground'}
    end

    -- Lua development
    use {'tjdevries/nlua.nvim'}

    -- Explorer
    use {'mhinz/vim-startify'}
    use { 'nvim-tree/nvim-tree.lua',
        lazy = true,
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional
        },
    }

    -- Status Line and Bufferline
    use {'glepnir/galaxyline.nvim',
        branch = 'main',
        config = function() require 'config.statusline' end,
        requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    }
    use {'romgrk/barbar.nvim',
        config = function() require 'config.barbar' end
    }
    use {'kosayoda/nvim-lightbulb',
        config = function() require 'config.lightbulb' end
    }

    use ("folke/which-key.nvim")

    -- Debugging
    --use {'puremourning/vimspector'}
    --use {'nvim-telescope/telescope-vimspector.nvim'}

    -- Git
    use {'lewis6991/gitsigns.nvim',
        config = function() require 'config.gitsigns' end
    }

    -- Comments
    use {'b3nj5m1n/kommentary'}

    -- -- DAP

    -- Latex
    -- use {'lervag/vimtex'}
    --

end)
