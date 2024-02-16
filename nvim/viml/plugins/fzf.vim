" plugin_fzf.vim
"

"" fzf {
" Starting fzf in a popup window
" Required:
" - width [float range [0 ~ 1]] or [integer range [8 ~ ]]
" - height [float range [0 ~ 1]] or [integer range [4 ~ ]]
"
" Optional:
" - xoffset [float default 0.5 range [0 ~ 1]]
" - yoffset [float default 0.5 range [0 ~ 1]]
" - border [string default 'rounded']: Border style
"   - 'rounded' / 'sharp' / 'horizontal' / 'vertical' / 'top' / 'bottom' / 'left' / 'right'
" let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 }
if g:fzf_enabled
    let g:fzf_command_prefix = 'Fzf'
    let g:fzf_nvim_statusline = 0 " disable statusline overwriting
    let $FZF_DEFAULT_OPTS="--ansi "
    "let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --layout reverse --margin=1,4"

    "" FZF popup's layout
    " window popup style
    " let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.3 } }
    " Border style (rounded / sharp / horizontal)
    let g:fzf_layout = { 'window': { 'width': 1.0, 'height': 0.6, 'highlight': 'Comment', 'border': 'sharp' } }
    " let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.3, 'highlight': 'Comment', 'xoffset': 0.5, 'yoffset': 0.5 , 'border': 'sharp' } }
    " popup down / up / left / right
    " let g:fzf_layout = { 'down': '30%' }
    " - Popup window (anchored to the bottom of the current window)
    " let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true, 'yoffset': 1.0 } }

    " - Window using a Vim command
    " let g:fzf_layout = { 'window': 'enew' }
    " let g:fzf_layout = { 'window': '-tabnew' }
    " let g:fzf_layout = { 'window': '10new' }

    "let g:fzf_preview_window = ['right:50%', 'ctrl-/']  " default"

    " An action can be a reference to a function that processes selected lines
    function! s:build_quickfix_list(lines)
      call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
      copen
      cc
    endfunction

    let g:fzf_action = {
      \ 'ctrl-q': function('s:build_quickfix_list'),
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

    " Customize fzf colors to match your color scheme
    " - fzf#wrap translates this to a set of `--color` options
    let g:fzf_colors = { 
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

    "nnoremap <silent> <leader>f :Files<CR>
    "nnoremap <silent> <leader>g :rg<CR>
    "nnoremap <silent> <leader>a :Buffers<CR>
    "nnoremap <silent> <leader>A :Windows<CR>
    "nnoremap <silent> <leader>; :BLines<CR>
    "nnoremap <silent> <leader>o :BTags<CR>
    "nnoremap <silent> <leader>O :Tags<CR>
    "nnoremap <silent> <leader>? :History<CR>
    "nnoremap <silent> <leader>/ :execute 'Ag ' . input('Ag/')<CR>
    "nnoremap <silent> <leader>. :AgIn 

    "nnoremap <silent> K :call SearchWordWithAg()<CR>
    "vnoremap <silent> K :call SearchVisualSelectionWithAg()<CR>
    "nnoremap <silent> <leader>gl :Commits<CR>
    "nnoremap <silent> <leader>ga :BCommits<CR>
    "nnoremap <silent> <leader>ft :Filetypes<CR>

    "imap <C-x><C-f> <plug>(fzf-complete-file-ag)
    "imap <C-x><C-l> <plug>(fzf-complete-line)

    function! RipgrepFzf(query, fullscreen)
        let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
        let initial_command = printf(command_fmt, shellescape(a:query))
        let reload_command = printf(command_fmt, '{q}')
        let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
        call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
    endfunction

    command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

    function! SearchWordWithAg()
        execute 'Ag' expand('<cword>')
    endfunction

    "function! SearchVisualSelectionWithAg() range
    "    let old_reg = getreg('"')
    "    let old_regtype = getregtype('"')
    "    let old_clipboard = &clipboard
    "    set clipboard&
    "    normal! ""gvy
    "    let selection = getreg('"')
    "    call setreg('"', old_reg, old_regtype)
    "    let &clipboard = old_clipboard
    "    execute 'Ag' selection
    "endfunction

    "command! -bang -nargs=? -complete=dir Files
    "\ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview', 'bat {}']}, <bang>0)
    command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)

    function! SearchWithRgInDirectory(...)
        call fzf#vim#(join(a:000[1:], ' '), extend({'dir': a:1}, g:fzf#vim#default_layout))
    endfunction
    command! -nargs=+ -complete=dir RgIn call SearchWithRgInDirectory(<f-args>)
endif
