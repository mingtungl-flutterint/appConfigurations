-- $Id lua/plugins/colorscheme.lua
-- vim:set ts=2 sw=2 sts=2 et:

require("catppuccin").setup({
  integrations = {
	cmp = true,
	--gitsigns = true,
	--nvimtree = true,
	--treesitter = true,
	--notify = false,
	which_key = false,
	telescope = {
		enabled = true,
		-- style = "nvchad"
	}
  }
})

vim.cmd.colorscheme "catppuccin-mocha"
-- catppuccin catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
