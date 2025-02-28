-- $Id lua/config/autocmds.lua
-- vim:set ts=2 sw=2 sts=2 et:

-- Custom autocmds and autogroups
--
local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
-- local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()

-----------------------------------------------------------------------------
-- Display {{{1
-----------------------------------------------------------------------------
vim.api.nvim_exec([[
    augroup cursorline_focus
        autocmd!
        autocmd WinEnter * setlocal cursorline
        autocmd WinLeave * setlocal nocursorline
    augroup END
    ]], false)

-- only show relative numbers in normal mode
-- dont show relative numbers when out of focus
vim.api.nvim_exec([[
    augroup relative_number
        autocmd!
        au InsertEnter * :set norelativenumber
        au InsertLeave * :set relativenumber
        au FocusLost * :set norelativenumber
        au FocusGained * :set relativenumber
    augroup END
    ]], false)

-- Highlight on yank
vim.cmd 'au TextYankPost * lua vim.highlight.on_yank {on_visual = false}'

-----------------------------------------------------------------------------
-- Terminal {{{1
-----------------------------------------------------------------------------
function _G.__split_term_right()
    execute('botright vsplit term://$SHELL')
    execute('setlocal nonumber')
    execute('setlocal norelativenumber')
    execute('startinsert')
end
vim.cmd("command TermRight :call luaeval('_G.__split_term_right()')")
-- Directly go into insert mode when switching to terminal
cmd [[autocmd BufWinEnter,WinEnter term://* startinsert]]
-- cmd [[autocmd BufLeave term://* stopinsert]]
-- Automatically close terminal buffer on process exit
-- cmd [[autocmd TermClose term://* call nvim_input('<CR>')]]
-- cmd [[autocmd TermClose * call feedkeys("i")]]

-----------------------------------------------------------------------------
-- Executions {{{1
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- Auto format
-----------------------------------------------------------------------------
-- vim.api.nvim_exec([[
-- augroup auto_fmt
--     autocmd!
--     autocmd BufWritePre *.py,*.lua undojoin | Neoformat
-- aug END
-- ]], false)

vim.api.nvim_exec([[
augroup auto_spellcheck
    autocmd!
    autocmd BufNewFile,BufRead *.md setlocal spell
    autocmd BufNewFile,BufRead *.org setfiletype markdown
    autocmd BufNewFile,BufRead *.org setlocal spell
augroup END
]], false)

vim.api.nvim_exec([[
augroup auto_term
    autocmd!
    autocmd TermOpen * setlocal nonumber norelativenumber
    autocmd TermOpen * startinsert
augroup END
]], false)

vim.api.nvim_exec([[
    fun! TrimWhitespace()
        let l:save = winsaveview()
        keeppatterns %s/\s\+$//e
        call winrestview(l:save)
    endfun

    autocmd BufWritePre * :call TrimWhitespace()
]], false)

-----------------------------------------------------------------------------
-- Buffers
-----------------------------------------------------------------------------
-- In the quickfix window, <CR> is used to jump to the error under the
-- cursor, so undefine the mapping there.
cmd [[ autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR> ]]

-----------------------------------------------------------------------------
-- }}}1
-----------------------------------------------------------------------------
