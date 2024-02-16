-- $Id init.lua
-- Main init file

-- local gvars = require('globalvariables')
require('before')

-- Sensible defaults
require('settings')

-- Install plugins
require('plugins')

-- to invoke a group of configurations in 'config' folder
-- will call config/init.lua
require('config')
-- to invoke individual configuration
-- require('config.colorscheme')  -- color scheme

-- Language Server Protocols (LSP)
DATA_PATH = vim.fn.stdpath('data')
CACHE_PATH = vim.fn.stdpath('cache')

if jit.os ~= 'Windows' then
    require('lsp')
end
-- Key mappings
require('config.keymappings')
require('config.whichkey')

-- Autocommands
require('config.autocommands')

-- DAP
-- require('dbg')

-- vimrc.after
require('after')
