-- $Id lua/before.lua
--
-- local gvars = require ('globalvariables')
-- This is a module
local M = {}

----------------------------------------------------------------------------------
-- local functions
-----
local function setProviders()
    -- Ruby
    vim.g.loaded_ruby_provider = 0
    vim.g.ruby_host_prog = ''

    -- Perl
    vim.g.loaded_perl_provider = 0
    vim.g.perl_host_prog = ''

    -- Nodejs
    -- vim.g.loaded_node_provider = 1
    -- vim.g.node_host_prog = '/usr/local/bin/neovim-node-host'

    -- Python
    -- Disable python2
    vim.g.loaded_python_provider = 0
    vim.g.python_host_prog = ''
    vim.g.loaded3_python_provider = 0
    vim.g.python3_host_prog = ''

    --[[
    if vim.fn.has('python') then
        vim.g.loaded_python_provider = 1
        vim.g.pymode_python = 'python'
        vim.g.python_host_prog = jit.os == 'Windows' and 'C:/Program Files/Python/python' or '/usr/bin/python'
        -- print ("has python2 at: ", vim.g.python_host_prog)
    end
    ]]

    if vim.fn.has('python3') then
        vim.g.loaded3_python_provider = 1
        vim.g.pymode_python = 'python3'
        vim.g.python3_host_prog = jit.os == 'Windows' and 'C:/Program Files/Python38/python' or '/usr/bin/python3'
        -- print ("has python3 at: ", vim.g.python3_host_prog)
    end
end

----------------------------------------------------------------------------------
-- global/exposed functions
-----
function M.before()
    --  Providers
    setProviders()
end

-- Call before() whence the module is required so caller need not call
M.before()

return M
