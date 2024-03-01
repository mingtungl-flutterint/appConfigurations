-- $Id lua/config/init.lua
--

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- Key mappings
require('config.keymappings')
require('config.whichkey')

-- Autocommands
require('config.autocommands')

require('config.colorscheme')
require('config.startify')
require('config.kommentary')
-- empty setup using defaults
--require('nvim-tree').setup()
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
