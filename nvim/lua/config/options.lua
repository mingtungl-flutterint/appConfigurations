-- $Id lua/config/options.lua
-- vim:set ts=2 sw=2 sts=2:
--

vim.g.autoformat = true

-- if the completion engine supports the AI source,
-- use that instead of inline suggestions
--vim.g.ai_cmp = true

-- Setting global options
local o  = vim.o
local opt = vim.opt

local function add(value, str, sep)
    sep = sep or ","
    str = str or ""
    value = type(value) == "table" and table.concat(value, sep) or value
    return str ~= "" and table.concat({value, str}, sep) or value
end



opt.autoindent = true  -- Indent at the same level of the previous line
opt.autowrite = true -- Enable auto write
-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically. Requires Neovim >= 0.10.0
opt.backspace = "indent,eol,start"  -- Backspace for dummies
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.cindent = true
opt.complete = add {"kspell"}
opt.completeopt = add {"menuone", "noselect", "noinsert", "longest"} -- Completion options
opt.compatible = false
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

opt.foldlevel = 99
--opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.jumpoptions = "view"
opt.laststatus = 3 -- global statusline
opt.linespace = 0                 -- No extra spaces between rows
opt.linebreak = true -- Wrap lines at convenient points
opt.list = true -- Show some invisible characters (tabs...
opt.magic = true
opt.modeline = false
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.ruler = false -- Disable the default ruler
opt.scrolloff = 4 -- Lines of context
opt.secure = true
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 4 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showcmd = false
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.softtabstop = 4
opt.spell = true  -- Spell checking on
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
opt.tabstop = 4 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmenu = true
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminheight = 0       -- Windows can be 0 line high
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap

-----------------------------------------------------------------------------
-- Backup
-----------------------------------------------------------------------------
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true -- Save undo history
opt.undolevels = 1000
opt.confirm = true -- prompt to save before destructive actions

-----------------------------------------------------------------------------
-- Search
-----------------------------------------------------------------------------
opt.ignorecase = true -- Ignore case
opt.smartcase = true -- Dont ignore case with capitals
opt.wrapscan = false -- Search wraps at end of file
opt.sidescrolloff = 4 -- Columns of context
opt.scrolljump = 5      -- Lines to scroll when cursor leaves screen
opt.scrolloff = 2      -- Minimum lines to keep above and below cursor
opt.showmatch = true
opt.incsearch = true     -- Find as you type search
opt.hlsearch = true     -- Highlight search terms


if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true
  opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
  opt.foldmethod = "expr"
  opt.foldtext = ""
else
  opt.foldmethod = "indent"
  opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
end


local api = vim.api
api.nvim_command("syntax on")
api.nvim_command("filetype plugin indent on")

-- Setting window-scoped options
local wo = vim.wo
wo.number = true -- Print line number
wo.relativenumber = true -- Relative line numbers
wo.numberwidth = 6
wo.signcolumn = 'auto'
wo.cursorline = true


-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0