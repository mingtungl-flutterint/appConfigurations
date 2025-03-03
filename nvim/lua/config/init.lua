-- $Id lua/config/init.lua
-- vim:set ts=2 sw=2 sts=2:
--

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

require('config.keymaps')
require('config.autocmds')
require('config.options')
--require('config.startify')
--require('config.kommentary')
--require('config.nvimtree')
--require('config.whichkey')
