local opt = require('utils').opt
local cmd = vim.cmd

-- Order is important
opt('o', 'termguicolors', true)
opt('o', 'background', 'dark')

-- cmd 'colorscheme onedark'
-- cmd 'colorscheme papercolor'
--cmd 'colorscheme gruvbox-material'
-- cmd 'colorscheme monokai'
cmd 'colorscheme catppuccin-mocha'
