-- $Id lua/settings.lua
--
local cmd = vim.cmd
local fn = vim.fn
local api = vim.api

local o  = vim.o  -- for setting global options
local bo = vim.bo -- for setting buffer-scoped options
local wo = vim.wo -- for setting window-scoped options
local g  = vim.g  -- for setting global variables

local executable = function(e) return fn.executable(e) > 0 end
local opts_info = api.nvim_get_all_options_info()
local opt = setmetatable({}, {
    __newindex = function(_, key, value)
        o[key] = value
        local scope = opts_info[key].scope
        if scope == "win" then
            wo[key] = value
        elseif scope == "buf" then
            bo[key] = value
        end
    end
})
local function add(value, str, sep)
    sep = sep or ","
    str = str or ""
    value = type(value) == "table" and table.concat(value, sep) or value
    return str ~= "" and table.concat({value, str}, sep) or value
end


-----------------------------------------------------------------------------
-- Utils {{{1
-----------------------------------------------------------------------------
api.nvim_command("syntax on")
api.nvim_command("filetype plugin indent on")
o.compatible = false
--o.t_Co = "256"
o.complete = add {"kspell"}
o.completeopt = add {"menuone", "noselect", "noinsert", "longest"} -- Completion options
o.clipboard = 'unnamedplus'
o.inccommand = 'nosplit'
-- o.mousehide = true  -- Hide the mouse cursor while typing
o.spell = true  -- Spell checking on
-- o.ruler rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) -- not needed
o.backspace = "indent,eol,start"  -- Backspace for dummies
o.linespace = 0                 -- No extra spaces between rows
o.showcmd = false
o.wildmenu = true
o.winminheight = 0       -- Windows can be 0 line high
o.secure = true
o.modeline = false
o.magic = true
o.conceallevel = 2
o.cscopetagorder = 0
o.cscopepathcomp = 3
o.cscopequickfix = "s-,c-,d-,i-,t-,e-"
-- o.showbreak       = string.rep('>', 3) -- Make it so that long lines wrap smartly
o.path = ".,,,**"
o.formatlistpat = [[^\\s*\\[({]\\?\\([0-9]\\+\\\|[a-zA-Z]\\+\\)[\\]:.)}]\\s\\+\\\|^\\s*[-–+o*•]\\s\\+]]
bo.formatoptions = "qcrn1"
-- o.formatoptions-=a    -- Auto formatting is BAD.
-- o.formatoptions-=t    -- Dont auto format my code. I got linters for that.
-- o.formatoptions+=c    -- In general, I like it when comments respect textwidth
-- o.formatoptions+=q    -- Allow formatting comments w/ gq
-- o.formatoptions-=o    -- O and o, dont continue comments
-- o.formatoptions+=r    -- But do continue when pressing enter.
-- o.formatoptions+=n    -- Indent past the formatlistpat, not underneath it.
-- o.formatoptions+=j    -- Auto-remove comments if possible.
-- o.formatoptions-=2    -- Im not in gradeschool anymore

-----------------------------------------------------------------------------
-- Indentation {{{1
-----------------------------------------------------------------------------
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 4 -- Size of an indent
opt.smartindent = true -- Insert indents automatically
opt.tabstop = 4 -- Number of spaces tabs count for
opt.softtabstop = 4
o.shiftround = true -- Round indent
o.joinspaces = false -- No double spaces with join after a dot
o.cindent = true
o.autoindent = true  -- Indent at the same level of the previous line

-----------------------------------------------------------------------------
-- Display {{{1
-----------------------------------------------------------------------------
wo.number = true -- Print line number
wo.relativenumber = true -- Relative line numbers
wo.numberwidth = 6
wo.signcolumn = 'auto'
wo.cursorline = true
opt.wrap = false
opt.linebreak = true -- wrap, but on words, not randomly
opt.textwidth = 200
opt.synmaxcol = 1024 -- dont syntax highlight long lines
g.vimsyn_embed = "lPr" -- allow embedded syntax highlighting for lua, python, ruby
-- o.showmode = true
o.showmode = false -- We dont need to see things like -- INSERT -- anymore
o.lazyredraw = true
o.emoji = false -- turn off as they are treated as double width characters
o.virtualedit = 'onemore' -- allow cursor to move past end of line
o.list = false -- dont show invisible chars
o.listchars = add { "eol: ", "tab:→ ", "extends:…", "precedes:…", "trail:·", "space: ", "nbsp:⣿" }
o.cmdheight = 2
-- cmd('set nolist') -- workaround until o mappings are fixed
o.shortmess = o.shortmess .. "I" -- disable :intro startup screen
--o.shortmess = o.shortmess .. 's'
o.display = "lastline"

-----------------------------------------------------------------------------
-- Title {{{1
-----------------------------------------------------------------------------
-- o.titlestring = "❐ %t"
o.titlestring = "❐ %F%=%l/%L"
o.titleold = '%{fnamemodify(getcwd(), ":t")}'
o.title = true
o.titlelen = 70

-----------------------------------------------------------------------------
-- Folds {{{1
-----------------------------------------------------------------------------
o.foldtext = "folds#render()"
o.foldenable = false  -- No Auto fold code
o.foldopen = add(o.foldopen, "search")
o.foldlevelstart = 10
opt.foldmethod = "indent"
o.foldnestmax = 10
o.fdc = "1"    -- foldcolumn
o.fdl = 1      -- foldlevel = 99

-----------------------------------------------------------------------------
-- Backup {{{1
-----------------------------------------------------------------------------
o.swapfile = false
o.backup = false
o.writebackup = false
opt.undofile = true -- Save undo history
o.undolevels = 1000
o.confirm = true -- prompt to save before destructive actions

-----------------------------------------------------------------------------
-- Search {{{1
-----------------------------------------------------------------------------
o.ignorecase = true -- Ignore case
o.smartcase = true -- Dont ignore case with capitals
o.wrapscan = false -- Search wraps at end of file
o.sidescrolloff = 4 -- Columns of context
o.scrolljump = 5      -- Lines to scroll when cursor leaves screen
o.scrolloff = 2      -- Minimum lines to keep above and below cursor
o.showmatch = true
o.incsearch = true     -- Find as you type search
o.hlsearch = true     -- Highlight search terms

---- Use fzf
--if executable("rg") then
--    o.grepprg = [[rg --glob "!.git" --smart-case --vimgrep $*]]
--    o.grepformat = add("%f:%l:%c:%m", o.grepformat)
--end
--cmd("command -bang -nargs=* Rg execute 'silent grep! <args>'")
--
-- Use faster grep alternatives if possible
if executable("rg") then
    o.grepprg = [[rg --glob "!.git" --smart-case --vimgrep $*]]
    o.grepformat = add("%f:%l:%c:%m", o.grepformat)
end
--cmd("command -bang -nargs=* Rg execute 'silent grep! <args>'")

-----------------------------------------------------------------------------
-- window splitting and buffers {{{1
-----------------------------------------------------------------------------
o.hidden = true -- Enable modified buffers in background
o.splitbelow = true -- Put new windows below current
o.splitright = true -- Put new windows right of current
o.fillchars = add {
    "vert:│", "fold: ", "diff:", -- alternatives: ⣿ ░
    "msgsep:‾", "foldopen:▾", "foldsep:│", "foldclose:▸",
    "stlnc:»","vert:║","fold:·"
}

-----------------------------------------------------------------------------
-- Wild and file globbing stuff in command mode {{{1
-----------------------------------------------------------------------------
o.autoread = true
o.fileformat = "unix"
o.nrformats = "bin,hex,alpha"
o.encoding = "UTF-8"
o.fileencodings = ""    -- Dont do any encoding conversion
o.wildmode = "longest,full"
o.wildignorecase = true -- Ignore case when completing file names and directories
-- Binary
o.wildignore = add {
    "*.aux,*.out,*.toc,*.exe,*.bak,*.swp",
    "*.o,*.obj,*.dll,*.jar,*.pyo,*.pyc,__pycache__,*.rbc,*.class", -- media
    "*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp",
    "*.PNG,*.JPG,*.JPEG,*.DS_Store",
    "*.avi,*.m4a,*.mp3,*.oga,*.ogg,*.wav,*.webm", "*.eot,*.otf,*.ttf,*.woff",
    "*.doc,*.pdf", -- archives
    "*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz", -- temp/system
    "*.*~,*~ ", "*.swp,.lock,.DS_Store,._*,tags.lock", -- version control
    "*/dist*/*,*/target/*,*/builds/*,tags,*/flow-typed/*,*/node_modules/*",
    ".git,.svn"
}
o.wildoptions = "pum"
o.pumblend = 3 -- Make popup window translucent
o.pumheight = 20 -- Limit the amount of autocomplete items shown

-----------------------------------------------------------------------------
-- Timings {{{1
-----------------------------------------------------------------------------
o.timeout = true
o.timeoutlen = 500
o.ttimeoutlen = 10
o.updatetime = 200

-----------------------------------------------------------------------------
-- Diff {{{1
-----------------------------------------------------------------------------
-- Use in vertical diff mode, blank lines to keep sides aligned, Ignore whitespace changes
o.diffopt = add({
    "vertical", "iwhite", "hiddenoff", "foldcolumn:0", "context:4",
    "algorithm:histogram", "indent-heuristic",
    "hiddenoff","iwhiteall","algorithm:patience"
}, o.diffopt)

-----------------------------------------------------------------------------
-- Mouse {{{1
-----------------------------------------------------------------------------
o.mouse = "a"

-----------------------------------------------------------------------------
-- Colorscheme {{{1
-----------------------------------------------------------------------------
-- see config/colorscheme

-----------------------------------------------------------------------------
-- Fonts {{{1
-----------------------------------------------------------------------------
-- o.guicursor = "n:blinkwait60-blinkon175-blinkoff175,i-ci-ve:ver25"
-- o.guifont = "FiraCode NF:h11"
-- o.guifont = "Cascadia Code PL:h11"

-----------------------------------------------------------------------------
-- }}}1
-----------------------------------------------------------------------------
