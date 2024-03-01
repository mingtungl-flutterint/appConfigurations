" $Id ginit.vim
"
" This file is only loaded in GUIs, nvim-qt in particular
" Neovim-qt Guifont command
" vimr doesn't support :Guifont

:GuiFont! FiraCode\ Nerd\ Font:h11
if !has("gui_vimr") && has('nvim')
   ":GuiFont! Cascadia\ Code\ PL:h12:cANSI
   :GuiFont! FiraCode\ Nerd\ Font:h11:cANSI
   :GuiTabline 0
   :GuiPopupmenu 0
   :GuiLinespace 1
   "set linespace=0  " a small linespace"
endif


""!! Uncomment renderoptions to render ligatures in gVim in MSWindows
"if WINDOWS() && !has('nvim')
if !has('nvim')
    set renderoptions=type:directx
endif

"if &wrap
"	set guioptions-=b
"else
"	set guioptions+=b
"endif

autocmd VimEnter * highlight Comment cterm=italic gui=italic
"set guicursor=n-v-c-sm:block,i-ci-ve:block,r-cr-o:blocks
"set lines=48 columns=155

" mouse copy paste
nnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>
inoremap <silent><RightMouse> <Esc>:call GuiShowContextMenu()<CR>
vnoremap <silent><RightMouse> :call GuiShowContextMenu()<CR>gv``
