vim.g.startify_custom_header = {
'',
'',
'                                       ██            ',
'                                      ░░             ',
'    ███████   █████   ██████  ██    ██ ██ ██████████ ',
'   ░░██░░░██ ██░░░██ ██░░░░██░██   ░██░██░░██░░██░░██',
'    ░██  ░██░███████░██   ░██░░██ ░██ ░██ ░██ ░██ ░██',
'    ░██  ░██░██░░░░ ░██   ░██ ░░████  ░██ ░██ ░██ ░██',
'    ███  ░██░░██████░░██████   ░░██   ░██ ███ ░██ ░██',
'   ░░░   ░░  ░░░░░░  ░░░░░░     ░░    ░░ ░░░  ░░  ░░ ',
'',
'',
}

vim.g.webdevicons_enable_startify = 1
vim.g.startify_enable_special = 1
vim.g.startify_session_autoload = 1
vim.g.startify_session_delete_buffers = 1
vim.g.startify_change_to_vcs_root = 1
vim.g.startify_fortune_use_unicode = 1
vim.g.startify_session_persistence = 1
vim.g.startify_files_number = 7

vim.g.startify_lists = {
    --{ type = 'files',       header = { '   MRU' } },
    { type = 'dir',         header = { "   Current Directory "..vim.fn.getcwd()..":" } },
    { type = 'bookmarks',   header = { '   Bookmarks' } },
    { type = 'sessions',    header = { '   Sessions' } },
    { type = 'commands',    header = { '   Commands' } }
}

if jit.os == 'Windows' then
    vim.g.startify_bookmarks = {
        { p = 'C:/Users/mingtungl/AppData/Local/nvim/lua/plugins.lua'},
        { i = 'C:/Users/mingtungl/AppData/Local/nvim/init.lua'},
        { k = 'C:/Users/mingtungl/AppData/Local/nvim/lua/config/keymappings.lua'},
    }
else
    vim.g.startify_bookmarks = {
        { p = '~/.config/nvim/lua/plugins.lua'},
        { i = '~/.config/nvim/init.lua'},
        { k = '~/.config/nvim/lua/config/keymappings.lua'},
        { z = '~/.zshrc'},
    }
end

-- vim.cmd([[
-- function! StartifyEntryFormat()
--         return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
-- endfunction
-- ]])

