-- $Id lua/after.lua
--
local gvar = require ('globalvariables')
-- This is a module
local M = {}

----------------------------------------------------------------------------------
-- local functions
-----
-- Windows Mapping
local function sourceWindowsMappings()
    if gvar.is_windows then
        vim.api.nvim_exec('source $VIMRUNTIME/mswin.vim', true)
    end
end


----------------------------------------------------------------------------------
-- global/exposed functions
-----
function M.after()
    sourceWindowsMappings()
end

-- Call after() whence the module is required so caller need not call
M.after()

return M
