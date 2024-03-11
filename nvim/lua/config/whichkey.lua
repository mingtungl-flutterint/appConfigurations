-- $Id lua/config/whichkey.lua
--
--vim.g.mapleader = " "
local g = vim.g

g.which_key_fallback_to_native_key = 1
g.which_key_display_names = {
    ['<CR>'] = '',    -- RETURN
    ['<TAB>'] = '',
    [' '] = '六',
    ['<A-...>'] = 'גּ',  -- ALT
    ['<M-...>'] = 'גּ',  -- META
    ['<C-...>'] = 'דּ',  -- CTRL
    ['<S-...>'] = '',  -- SHIFT
}
g.which_key_sep = '→'
g.which_key_timeout = 100


local keymap = vim.keymap -- for conciseness
local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    return
end

local setup = {
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20, -- how many suggestions should be shown in the list?
        },
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
            operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = true, -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true, -- bindings for prefixed with g
        },
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    -- operators = { gc = "Comments" },
    key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        ["<space>"] = "SPC",
        ["<cr>"] = "RET",
        ["<tab>"] = "TAB",
    },
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
    },
    popup_mappings = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
    },
    window = {
        border = "rounded", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 0,
    },
    layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "center", -- align columns left, center or right
    },
    ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
    show_help = true, -- show help message on the command line when the popup is visible
    triggers = "auto", -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specify a list manually
    triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { "j", "k" },
        v = { "j", "k" },
    },
}

local opts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
    ['<CR>'] = {'@q', 'macro q'}, -- setting a special key
    ['<F3>'] = {'<cmd>e $MYVIMRC<CR>', 'Open VIMRC'},
    ['<F4>'] = {'<cmd>luafile $MYVIMRC<CR> | <cmd>echo "sourced " . $MYVIMRC<cr>', 'Source VIMRC'},
    ['?'] = {
        name = 'Explorer',
        c = {'<cmd>NvimTreeClose<CR>', 'close'},
        f = {'<cmd>NvimTreeFindFile<CR>', 'find file'},
        o = {'<cmd>NvimTreeOpen<CR>', 'open'},
        r = {'<cmd>NvimTreeRefresh<CR>', 'refresh'},
        t = {'<cmd>NvimTreeToggle<CR>', 'toggle'},
    },
    --["A"] = { "<cmd>Alpha<cr>", "Alpha" },
    --["B"] = {
    --    "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
    --    "Buffers",
    --},
    ["c"] = { "<cmd>bdelete!<CR>", "Close Buffer" },
    ["n"] = { function()
        vim.api.nvim_command('lcd %:p:h')
        vim.api.nvim_command('tabnew')
        end, 'New Tab'},
    ['s'] = {
        name = 'Text Search',
        ["c"] = { '<cmd>nohlsearch<CR> | <cmd>echo "Previous search cleared"<CR>', 'Clear search' },
        ["h"] = { '<cmd>nohl<CR>', 'NoHL' },
    },
    ["q"] = { "<cmd>q!<CR>", "Quit" },
    ["w"] = { "<cmd>w!<CR>", "Save" },

    B = {
        name = 'Buffer' ,
        --['>'] = {':BufferMoveNext', 'move next'},     -- barbar.vim
        --['<' ]= {':BufferMovePrevious', 'move prev'}, -- barbar.vim
        ['1'] = {'b1<cr>', 'buffer 1'},
        ['2'] = {'b2<cr>', 'buffer 2'},
        -- b = {':BufferPick', 'pick buffer'},  -- barbar.vim
        d = {'<cmd>bd<cr>', 'Close buffer'},
        n = {'<cmd>bnext<cr>', 'next'},
        p = {'<cmd>bprevious<cr>', 'previous'},
        ['?'] = {'<cmd>buffers[!]<cr>', 'all buffers'}
    },
    F = {
        name = 'Fold',
        O = {'<cmd>set foldlevel=20'  , 'open all'},
        C = {'<cmd>set foldlevel=0'   , 'close all'},
        c = {'<cmd>foldclose'         , 'close'},
        o = {'<cmd>foldopen'          , 'open'},
        ['1'] = {'<cmd>set foldlevel=1'   , 'level1'},
        ['2'] = {'<cmd>set foldlevel=2'   , 'level2'},
        ['3'] = {'<cmd>set foldlevel=3'   , 'level3'},
        ['4'] = {'<cmd>set foldlevel=4'   , 'level4'},
        ['5'] = {'<cmd>set foldlevel=5'   , 'level5'},
        ['6'] = {'<cmd>set foldlevel=6<cr>'   , 'level6'}
    },
    -- Packer
    P = {
        name = 'Packer',
        c = { '<cmd>PackerCompile<cr>', 'Compile' },
        i = { '<cmd>PackerInstall<cr>', 'Install' },
        s = { '<cmd>PackerSync<cr>', 'Sync' },
        S = { '<cmd>PackerStatus<cr>', 'Status' },
        u = { '<cmd>PackerUpdate<cr>', 'Update' },
    },
    -- Git
    G = {
        name = 'Git',
        b = { '<cmd>Telescope git_branches<cr>', 'Checkout branch' },
        c = { '<cmd>Telescope git_commits<cr>', 'Checkout commit' },
        d = { '<cmd>Gitsigns diffthis HEAD<cr>', 'Diff' },
        g = { '<cmd>lua _LAZYGIT_TOGGLE()<CR>', 'Lazygit' },
        j = { '<cmd>lua require "gitsigns".next_hunk()<cr>', 'Next Hunk' },
        k = { '<cmd>lua require "gitsigns".prev_hunk()<cr>', 'Prev Hunk' },
        l = { '<cmd>lua require "gitsigns".blame_line()<cr>', 'Blame' },
        o = { '<cmd>Telescope git_status<cr>', 'Open changed file' },
        p = { '<cmd>lua require "gitsigns".preview_hunk()<cr>', 'Preview Hunk' },
        r = { '<cmd>lua require "gitsigns".reset_hunk()<cr>', 'Reset Hunk' },
        R = { '<cmd>lua require "gitsigns".reset_buffer()<cr>', 'Reset Buffer' },
        s = { '<cmd>lua require "gitsigns".stage_hunk()<cr>', 'Stage Hunk' },
        u = { '<cmd>lua require "gitsigns".undo_stage_hunk()<cr>', 'Undo Stage Hunk' },
    },
    --Telescope
    T = { -- set a nested structure
        name = 'Telescope',
        ['?'] = {'<Cmd>Telescope help_tags<CR>', 'help tags'},
        b = {'<Cmd>Telescope buffers<CR>', 'buffers'},
        c = {
            name = '+commands',
            c = {'<Cmd>Telescope commands<CR>', 'commands'},
            h = {'<Cmd>Telescope command_history<CR>', 'history'},
        },
        f = {'<Cmd>Telescope find_files<CR>', 'Find file'},
        F = { '<cmd>Telescope live_grep theme=ivy<cr>', 'Find Text' },
        g = { '<cmd>lua require("telescope").extensions.live_grep_args.live_grep_args()<cr>', 'Live grep' },
        h = {'<Cmd>Telescope command_history<CR>', 'history'},
        i = {'<Cmd>Telescope media_files<CR>', 'media files'},
        k = { '<cmd>Telescope keymaps<cr>', 'Keymaps' },
        m = {'<Cmd>Telescope marks<CR>', 'marks'},
        M = {'<Cmd>Telescope man_pages<CR>', 'man_pages'},
        o = {'<Cmd>Telescope vim_options<CR>', 'vim_options'},
        P = {'<cmd>lua require("telescope").extensions.projects.projects()<cr>', 'Projects' },
        q = {'<Cmd>Telescope quickfix<CR>', 'quickfix'},
        r = {'<Cmd>Telescope registers<CR>', 'registers'},
        R = { '<cmd>Telescope oldfiles<cr>', 'Open Recent File' },
        --t = {'<Cmd>Telescope filetypes<CR>', 'filetypes'},
        u = {'<Cmd>Telescope colorscheme<CR>', 'colorschemes'},
        w = {'<Cmd>Telescope file_browser<CR>', 'File browser'},
    },
-- Terminal
--    T = {
--        name = "Terminal",
--        n = { "<cmd>lua _NODE_TOGGLE()<cr>", "Node" },
--        u = { "<cmd>lua _NCDU_TOGGLE()<cr>", "NCDU" },
--        t = { "<cmd>lua _HTOP_TOGGLE()<cr>", "Htop" },
--        p = { "<cmd>lua _PYTHON_TOGGLE()<cr>", "Python" },
--        f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
--        h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
--        v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
--    },
}

which_key.setup(setup)
which_key.register(mappings, opts)

