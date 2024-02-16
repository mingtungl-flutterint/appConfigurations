-- $Id lua/keymappings.lua
-- Custom key bindings
--
local map = require('utils').map

-----------------------------------------------------------------------------
-- Mappings {{{1
-----------------------------------------------------------------------------
-- set leader to space
vim.g.mapleader = ' '
vim.g.maplocalleader = ','
map('n', '<Space>', '<Nop>')
map('n', ',', '<Nop>')
-- <space><space> switches between buffers
-- map('n', '<leader><leader>', ':b#<CR>')

-- movements that work on long wrapped lines
map('', 'j', "(v:count ? 'j' : 'gj')", {expr = true})
map('', 'k', "(v:count ? 'k' : 'gk')", {expr = true})

-- Disable arrow keys
-- map('n', '<Up>', '<Nop>')
-- map('n', '<Down>', '<Nop>')
-- map('n', '<Left>', '<Nop>')
-- map('n', '<Right>', '<Nop>')
-- map('i', '<Up>', '<Nop>')
-- map('i', '<Down>', '<Nop>')
-- map('i', '<Left>', '<Nop>')
-- map('i', '<Right>', '<Nop>')

-- Splits navigation
-- So instead of ctrl-w then j, it’s just ctrl-j
-- map('i', '<C-j>', '<C-w>j')
-- map('i', '<C-k>', '<C-w>k')
-- map('i', '<C-h>', '<C-w>h')
-- map('i', '<C-l>', '<C-w>l')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-h>', '<C-w>h')
map('n', '<C-l>', '<C-w>l')

-- some key bindings for tabs
--  Alt+Tab   : go to the next tab.
--  Shift+Tab : go to the previous tab.
map('n', '<M-Tab>', ':tabn<CR>')
map('n', '<S-Tab>', ':tabp<CR>')

-- Use alt + hjkl to resize windows
-- map('n', '<M-j>', '<cmd>resize -2<CR>')
-- map('n', '<M-k>', '<cmd>resize +2<CR>')
-- map('n', '<M-h>', '<cmd>vertical resize -2<CR>')
-- map('n', '<M-l>', '<cmd>vertical resize +2<CR>')

-- Terminal window navigation
-- map('t', '<C-h>', '<C-\\><C-N><C-w>h')
-- map('t', '<C-j>', '<C-\\><C-N><C-w>j')
-- map('t', '<C-k>', '<C-\\><C-N><C-w>k')
-- map('t', '<C-l>', '<C-\\><C-N><C-w>l')
-- map('t', '<C-h>', '<C-\\><C-N><C-w>h')
-- map('t', '<C-j>', '<C-\\><C-N><C-w>j')
-- map('t', '<C-k>', '<C-\\><C-N><C-w>k')
-- map('t', '<C-l>', '<C-\\><C-N><C-w>l')
-- map('t', '<Esc>', '<C-\\><C-N>')
-- map('t', '<C-[>', '<C-\\><C-N>')
map('t', '<C-[><C-[>', '<C-\\><C-N>') -- double ESC to escape terminal

-- Better indenting
-- map('v', '<', '<gv')
-- map('v', '>', '>gv')

-- Move selected line / block of text in visual mode
-- shift + k to move up
-- shift + j to move down
-- map('x', 'K', ":move '<-2<CR>gv-gv")
-- map('x', 'J', ":move '>+1<CR>gv-gv")

-- ctrl + a: select all
map('n', '<C-a>', '<esc>ggVG<CR>')

-- sensible defaults
map('', 'Y', 'y$')
map('', 'Q', '')

-- edit & source init.lua
-- map('n', '<Leader>v', ':e $MYVIMRC<CR>')
-- map('n', '<Leader>s', ':luafile $MYVIMRC<CR>')

-- To remove highlight from searched word
-- C-l redraws the screen. We change it so that it also removes all highlights
-- C-u so that we remove any ranges which might be there due to visual mode
-- map('n', '<leader>', ':<C-u>noh<CR><C-l>')

-- highlight search
-- map('n', '<Leader>h', ':set hlsearch!<CR>')
-- map('n', '<Leader>h', ':let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>')
-----------------------------------------------------------------------------
-- }}}1
-----------------------------------------------------------------------------
