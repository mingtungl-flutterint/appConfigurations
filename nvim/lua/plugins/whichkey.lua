-- $Id lua/config/whichkey.lua
-- vim:set ts=2 sw=2 sts=2 et:

local g = vim.g

g.which_key_fallback_to_native_key = 1
g.which_key_display_names = {
    ['<CR>'] = 'ï ',    -- RETURN
    ['<TAB>'] = 'ï ‘',
    [' '] = 'ï§‘',
    ['<A-...>'] = 'ï¬²',  -- ALT
    ['<M-...>'] = 'ï¬²',  -- META
    ['<C-...>'] = 'ï¬³',  -- CTRL
    ['<S-...>'] = 'ï…ˆ',  -- SHIFT
}
g.which_key_sep = 'â†’'
g.which_key_timeout = 100


local keymap = vim.keymap -- for conciseness

local wk = require("which-key")
wk.add({
  { "<leader><CR>", "@q", desc = "macro q", nowait = true, remap = false },
  { "<leader>?", group = "Explorer", nowait = true, remap = false },
  { "<leader>?c", ":NvimTreeClose<CR>", desc = "close", nowait = true, remap = false },
  { "<leader>?f", ":NvimTreeFindFile<CR>", desc = "find file", nowait = true, remap = false },
  { "<leader>?o", ":NvimTreeOpen<CR>", desc = "open", nowait = true, remap = false },
  { "<leader>?r", ":NvimTreeRefresh<CR>", desc = "refresh", nowait = true, remap = false },
  { "<leader>?t", ":NvimTreeToggle<CR>", desc = "toggle", nowait = true, remap = false },
  { "<leader>F", group = "Fold", nowait = true, remap = false },
  { "<leader>F1", ":set foldlevel=1", desc = "level1", nowait = true, remap = false },
  { "<leader>F2", ":set foldlevel=2", desc = "level2", nowait = true, remap = false },
  { "<leader>F3", ":set foldlevel=3", desc = "level3", nowait = true, remap = false },
  { "<leader>F4", ":set foldlevel=4", desc = "level4", nowait = true, remap = false },
  { "<leader>F5", ":set foldlevel=5", desc = "level5", nowait = true, remap = false },
  { "<leader>F6", ":set foldlevel=6<cr>", desc = "level6", nowait = true, remap = false },
  { "<leader>FC", ":set foldlevel=0", desc = "close all", nowait = true, remap = false },
  { "<leader>FO", ":set foldlevel=20", desc = "open all", nowait = true, remap = false },
  { "<leader>Fc", ":foldclose", desc = "close", nowait = true, remap = false },
  { "<leader>Fo", ":foldopen", desc = "open", nowait = true, remap = false },
  { "<leader>T", group = "Terminal", nowait = true, remap = false },
  { "<leader>Tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Float", nowait = true, remap = false },
  { "<leader>Th", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "Horizontal", nowait = true, remap = false },
  { "<leader>Tn", "<cmd>lua _NODE_TOGGLE()<cr>", desc = "Node", nowait = true, remap = false },
  { "<leader>Tp", "<cmd>lua _PYTHON_TOGGLE()<cr>", desc = "Python", nowait = true, remap = false },
  { "<leader>Tt", "<cmd>lua _HTOP_TOGGLE()<cr>", desc = "Htop", nowait = true, remap = false },
  { "<leader>Tu", "<cmd>lua _NCDU_TOGGLE()<cr>", desc = "NCDU", nowait = true, remap = false },
  { "<leader>Tv", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "Vertical", nowait = true, remap = false },
--  { "<leader>B", group = "buffers", expand = function() return require("which-key.extras").expand.buf() end },
  { "<leader>b", group = "Buffer", nowait = true, remap = false },
  { "<leader>b1", "b1<cr>", desc = "buffer 1", nowait = true, remap = false },
  { "<leader>b2", "b2<cr>", desc = "buffer 2", nowait = true, remap = false },
  { "<leader>b?", ":buffers[!]<cr>", desc = "all buffers", nowait = true, remap = false },
  { "<leader>bd", ":bd", desc = "delete", nowait = true, remap = false },
  { "<leader>bn", ":bnext<cr>", desc = "next", nowait = true, remap = false },
  { "<leader>bp", ":bprevious<cr>", desc = "previous", nowait = true, remap = false },
  { "<leader>bc", "<cmd>Bdelete!<CR>", desc = "Close Buffer", nowait = true, remap = false },
  { "<leader>g", group = "Git", nowait = true, remap = false },
  { "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", desc = "Reset Buffer", nowait = true, remap = false },
  { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch", nowait = true, remap = false },
  { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Checkout commit", nowait = true, remap = false },
  { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Diff", nowait = true, remap = false },
  { "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", desc = "Lazygit", nowait = true, remap = false },
  { "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk()<cr>", desc = "Next Hunk", nowait = true, remap = false },
  { "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", desc = "Prev Hunk", nowait = true, remap = false },
  { "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>", desc = "Blame", nowait = true, remap = false },
  { "<leader>go", "<cmd>Telescope git_status<cr>", desc = "Open changed file", nowait = true, remap = false },
  { "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", desc = "Preview Hunk", nowait = true, remap = false },
  { "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", desc = "Reset Hunk", nowait = true, remap = false },
  { "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", desc = "Stage Hunk", nowait = true, remap = false },
  { "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo Stage Hunk", nowait = true, remap = false },
  { "<leader>h", "<cmd>nohlsearch<CR>", desc = "No Highlight", nowait = true, remap = false },
  { "<leader>p", group = "Packer", nowait = true, remap = false },
  { "<leader>pS", "<cmd>PackerStatus<cr>", desc = "Status", nowait = true, remap = false },
  { "<leader>pc", "<cmd>PackerCompile<cr>", desc = "Compile", nowait = true, remap = false },
  { "<leader>pi", "<cmd>PackerInstall<cr>", desc = "Install", nowait = true, remap = false },
  { "<leader>ps", "<cmd>PackerSync<cr>", desc = "Sync", nowait = true, remap = false },
  { "<leader>pu", "<cmd>PackerUpdate<cr>", desc = "Update", nowait = true, remap = false },
  { "<leader>q", "<cmd>q!<CR>", desc = "Quit", nowait = true, remap = false },
  { "<leader>t", group = "Telescope", nowait = true, remap = false },
  { "<leader>t?", "<Cmd>Telescope help_tags<CR>", desc = "help tags", nowait = true, remap = false },
  { "<leader>tF", "<cmd>Telescope live_grep theme=ivy<cr>", desc = "Find Text", nowait = true, remap = false },
  { "<leader>tM", "<Cmd>Telescope man_pages<CR>", desc = "man_pages", nowait = true, remap = false },
  { "<leader>tP", "<cmd>lua require('telescope').extensions.projects.projects()<cr>", desc = "Projects", nowait = true, remap = false },
  { "<leader>tR", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File", nowait = true, remap = false },
  { "<leader>tb", "<Cmd>Telescope buffers<CR>", desc = "buffers", nowait = true, remap = false },
  { "<leader>tc", group = "commands", nowait = true, remap = false },
  { "<leader>tcc", "<Cmd>Telescope commands<CR>", desc = "commands", nowait = true, remap = false },
  { "<leader>tch", "<Cmd>Telescope command_history<CR>", desc = "history", nowait = true, remap = false },
  { "<leader>tf", "<Cmd>Telescope find_files<CR>", desc = "Find file", nowait = true, remap = false },
  { "<leader>tg", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>", desc = "Live grep", nowait = true, remap = false },
  { "<leader>th", "<Cmd>Telescope command_history<CR>", desc = "history", nowait = true, remap = false },
  { "<leader>ti", "<Cmd>Telescope media_files<CR>", desc = "media files", nowait = true, remap = false },
  { "<leader>tk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps", nowait = true, remap = false },
  { "<leader>tm", "<Cmd>Telescope marks<CR>", desc = "marks", nowait = true, remap = false },
  { "<leader>to", "<Cmd>Telescope vim_options<CR>", desc = "vim_options", nowait = true, remap = false },
  { "<leader>tq", "<Cmd>Telescope quickfix<CR>", desc = "quickfix", nowait = true, remap = false },
  { "<leader>tr", "<Cmd>Telescope registers<CR>", desc = "registers", nowait = true, remap = false },
  { "<leader>tu", "<Cmd>Telescope colorscheme<CR>", desc = "colorschemes", nowait = true, remap = false },
  { "<leader>tw", "<Cmd>Telescope file_browser<CR>", desc = "File browser", nowait = true, remap = false },
  { "<leader>w", "<cmd>w!<CR>", desc = "Save", nowait = true, remap = false },
})

-- Show hydra mode for changing windows
--[[
require("which-key").show({
  keys = "<c-w>",
  loop = true, -- this will keep the popup open until you hit <esc>
})
]]
