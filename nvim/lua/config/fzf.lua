--  $Id lua/config/fzf.lua
-- vim:set ts=2 sw=2 sts=2 et:
--  fzf {
--  Starting fzf in a popup window
--  Required:
--  - width [float range [0 ~ 1]] or [integer range [8 ~ ]]
--  - height [float range [0 ~ 1]] or [integer range [4 ~ ]]
--
--  Optional:
--  - xoffset [float default 0.5 range [0 ~ 1]]
--  - yoffset [float default 0.5 range [0 ~ 1]]
--  - border [string default 'rounded']: Border style
--    - 'rounded' / 'sharp' / 'horizontal' / 'vertical' / 'top' / 'bottom' / 'left' / 'right'
--  vim.g.fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 }
vim.g.fzf_command_prefix = 'Fzf'
vim.g.fzf_nvim_statusline = 0  -- disable statusline overwriting
-- let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --layout reverse --margin=1,4"

--  FZF popup's layout
--  window popup style
--  vim.g.fzf_layout = { 'window': { 'width': 0.9, 'height': 0.3 } }
--  Border style (rounded / sharp / horizontal)
vim.g.fzf_layout = { 'window': { 'width': 1.0, 'height': 0.6, 'highlight': 'Comment', 'border': 'sharp' } }
--  vim.g.fzf_layout = { 'window': { 'width': 0.9, 'height': 0.3, 'highlight': 'Comment', 'xoffset': 0.5, 'yoffset': 0.5 , 'border': 'sharp' } }
--  popup down / up / left / right
--  vim.g.fzf_layout = { 'down': '30%' }
--  - Popup window (anchored to the bottom of the current window)
--  vim.g.fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true, 'yoffset': 1.0 } }

--  - Window using a Vim command
--  vim.g.fzf_layout = { 'window': 'enew' }
--  vim.g.fzf_layout = { 'window': '-tabnew' }
--  vim.g.fzf_layout = { 'window': '10new' }

-- vim.g.fzf_preview_window = ['right:50%', 'ctrl-/']  " default"

--  An action can be a reference to a function that processes selected lines
local build_quickfix_list = vim.api.nvim_exec(
[[
    function! s:build_quickfix_list(lines)
        call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
        copen
        cc
    endfunction
]], true)

vim.g.fzf_action = {
    \ 'ctrl-q': 'build_quickfix_list',
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vsplit' }

--  Customize fzf colors to match your color scheme
--  - fzf#wrap translates this to a set of `--color` options
vim.g.fzf_colors = {
\ 'fg':      ['fg', 'Normal'],
\ 'bg':      ['bg', 'Normal'],
\ 'hl':      ['fg', 'Comment'],
\ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
\ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
\ 'hl+':     ['fg', 'Statement'],
\ 'info':    ['fg', 'PreProc'],
\ 'border':  ['fg', 'Ignore'],
\ 'prompt':  ['fg', 'Conditional'],
\ 'pointer': ['fg', 'Exception'],
\ 'marker':  ['fg', 'Keyword'],
\ 'spinner': ['fg', 'Label'],
\ 'header':  ['fg', 'Comment']
\ }

-- nnoremap <silent> <leader>f :Files<CR>
-- nnoremap <silent> <leader>g :rg<CR>
-- nnoremap <silent> <leader>a :Buffers<CR>
-- nnoremap <silent> <leader>A :Windows<CR>
-- nnoremap <silent> <leader>; :BLines<CR>
-- nnoremap <silent> <leader>o :BTags<CR>
-- nnoremap <silent> <leader>O :Tags<CR>
-- nnoremap <silent> <leader>? :History<CR>
-- nnoremap <silent> <leader>/ :execute 'Ag ' . input('Ag/')<CR>
-- nnoremap <silent> <leader>. :AgIn

-- nnoremap <silent> K :call SearchWordWithAg()<CR>
-- vnoremap <silent> K :call SearchVisualSelectionWithAg()<CR>
-- nnoremap <silent> <leader>gl :Commits<CR>
-- nnoremap <silent> <leader>ga :BCommits<CR>
-- nnoremap <silent> <leader>ft :Filetypes<CR>

-- imap <C-x><C-f> <plug>(fzf-complete-file-ag)
-- imap <C-x><C-l> <plug>(fzf-complete-line)

local build_quickfix_list = vim.api.nvim_exec(
[[
    function! RipgrepFzf(query, fullscreen)
        let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
        let initial_command = printf(command_fmt, shellescape(a:query))
        let reload_command = printf(command_fmt, '{q}')
        let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
        call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
    endfunction
    command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)
]], true)


vim.cmd("command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', 'bat {}']}, <bang>0)")
--vim.cmd("command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)")

vim.api.nvim_exec(
[[
    function! SearchWithRgInDirectory(...)
        call fzf#vim#(join(a:000[1:], ' '), extend({'dir': a:1}, g:fzf#vim#default_layout))
    endfunction
    command! -nargs=+ -complete=dir RgIn call SearchWithRgInDirectory(<f-args>)
]], true)
