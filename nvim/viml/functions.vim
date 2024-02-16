""" custom_functions.vim

" Trim Whitespaces
function! TrimWhitespace()
    let l:save = winsaveview()
    %s/\\\@<!\s\+$//e
    call winrestview(l:save)
endfunction

" Dracula Mode (Dark)
function! ColorDracula()
   let g:airline_theme=''
   color dracula
   IndentLinesEnable
endfunction

""!! fast toggling
function! NumberToggle()
    if(&relativenumber == 1)
        set norelativenumber
    else
        set relativenumber
    endif
endfunc

""!! Get buffer width
function! BufWidth()
  let numberwidth = max([&numberwidth, strlen(line('$'))+1])
  let l:numwidth = (&number || &relativenumber)? numberwidth : 0
  let l:foldwidth = &foldcolumn

  if &signcolumn == 'yes'
    let l:signwidth = 2
  elseif &signcolumn == 'auto'
    let l:signs = execute(printf('sign place buffer=%d', bufnr('')))
    let l:signs = split(signs, "\n")
    let l:signwidth = len(l:signs)>2? 2: 0
  else
    let l:signwidth = 0
  endif
  let &columns = winwidth(0) - l:numwidth - l:foldwidth - l:signwidth
  "let &columns = winwidth(0) - l:numwidth - l:foldwidth - l:signwidth
endfunction

""!! Wrap text at BuferWidth
function! SoftwrapColumnsToBufSize()
    autocmd!
    autocmd VimResized * | call BufWidth() | setlocal wrap | setlocal linebreak | setlocal showbreak=...
endfunction

"augroup softwrapText
"    autocmd!
"    autocmd BufRead,BufNewFile *.txt,*.vim,*.ini call SoftwrapColumnsToBufSize()
"augroup END
