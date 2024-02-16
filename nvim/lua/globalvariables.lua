--- lua/gvarsvariables.lua
-- gvars variables

O = {
    auto_close_tree = 0,
    auto_complete = true,
    colorscheme = 'lunar',
    hidden_files = true,
    wrap_lines = false,
    number = true,
    relative_number = true,
    shell = 'bash',

    -- @usage pass a table with your desired languages
    treesitter = {
        ensure_installed = "all",
        ignore_install = {"haskell"},
        highlight = {enabled = true},
        playground = {enabled = true},
        rainbow = {enabled = false}
    },

    database = {save_location = '~/.config/nvcode_db', auto_execute = 1},
    python = {
        linter = '',
        -- @usage can be 'yapf', 'black'
        formatter = '',
        autoformat = false,
        isort = false,
        diagnostics = {virtual_text = true, signs = true, underline = true}
    },
    dart = {sdk_path = '/usr/lib/dart/bin/snapshots/analysis_server.dart.snapshot'},
    lua = {
        -- @usage can be 'lua-format'
        formatter = '',
        autoformat = false,
        diagnostics = {virtual_text = true, signs = true, underline = true}
    },
    sh = {
        -- @usage can be 'shellcheck'
        linter = '',
        -- @usage can be 'shfmt'
        formatter = '',
        autoformat = false,
        diagnostics = {virtual_text = true, signs = true, underline = true}
    },
    tsserver = {
        -- @usage can be 'eslint'
        linter = '',
        -- @usage can be 'prettier'
        formatter = '',
        autoformat = false,
        diagnostics = {virtual_text = true, signs = true, underline = true}
    },
    json = {
        -- @usage can be 'prettier'
        formatter = '',
        autoformat = false,
        diagnostics = {virtual_text = true, signs = true, underline = true}
    },
    tailwindls = {filetypes = {'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact'}},
    clang = {diagnostics = {virtual_text = true, signs = true, underline = true}},
	ruby = {
		diagnostics = {virtualtext = true, signs = true, underline = true},
		filetypes = {'rb', 'erb', 'rakefile'}
	}
    -- css = {formatter = '', autoformat = false, virtual_text = true},
    -- json = {formatter = '', autoformat = false, virtual_text = true}
}

-- Debug flag: DEBUG
local gvars = { DEBUG = 'false'}

-- M.is_windows = vim.loop.os_uname().sysname == "Windows" and true or false
-- M.is_windows = vim.loop.os_uname().version:match("Windows")
-- M.is_linux = vim.loop.os_uname().version:match("Linux")

gvars.is_mac     = jit.os == 'OSX'
gvars.is_linux   = jit.os == 'Linux'
gvars.is_windows = jit.os == 'Windows'

if gvars.is_windows then
    local win_home = 'C:\\users\\' .. os.getenv('USERNAME')
end

gvars.home = gvars.is_windows and win_home or os.getenv("HOME")
gvars.path_sep = gvars.is_windows and '\\' or '/'

gvars.packer_start_path = vim.fn.stdpath('data') .. '/site/pack/packer/start'
gvars.packer_opt_path = vim.fn.stdpath('data') .. '/site/pack/packer/opt'
gvars.nvim_config_path = vim.fn.stdpath('config')
--gvars.vim_path    = self.home .. self.path_sep..'.config'..self.path_sep..'nvim'
--gvars.cache_dir   = self.home .. self.path_sep..'.cache'..self.path_sep..'vim'..self.path_sep
--gvars.modules_dir = self.vim_path .. self.path_sep..'modules'

-----------------------------------------------------------------------------
-- Local function definitions
--

-----------------------------------------------------------------------------
-- gvars function definitions
--
function gvars:load_variables()
    -- Debugging
    if self.DEBUG == 'true' then

        print ("Linux: ",  self.is_linux)
        print ("Windows: ",  self.is_windows)
        print ("home: ",  self.home)
        print ('install path: ', self.packer_start_path)
        print ('config path : ', self.nvim_config_path)
        print ("lua/gvarss.lua loaded successfully")
    end
end

gvars:load_variables()
return gvars
