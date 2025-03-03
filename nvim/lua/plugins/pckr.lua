-- lua/plugins/pckr.lua
-- vim:set ts=2 sw=2 sts=2 et:
-- This file can be loaded by calling `lua require('plugins')` from your init.vim

local cmd = require('pckr.loader.cmd')
local keys = require('pckr.loader.keys')

require('pckr').add {
	{
	  'nvim-lualine/lualine.nvim',
	  requires = { 'nvim-tree/nvim-web-devicons' }
	},
	{ 'catppuccin/nvim', as = 'catppuccin' },
	{ "folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		}
	},
    {
        'nvim-telescope/telescope.nvim',
        requires = { 'nvim-lua/plenary.nvim' }
    },

  -- Post-install/update hook with neovim command
  --{ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' };

}
