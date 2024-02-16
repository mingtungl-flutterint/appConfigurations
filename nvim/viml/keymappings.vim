" keymap_settings.vim
	""!! set Leader
	let mapleader = ' '
	let maplocalleader = ','
    nnoremap <Space> <Nop>
    "xnoremap <Space> <Nop>
    " <space><space> switches between buffers
    nnoremap <leader><leader> :b#<CR>

""" Key (re)Mappings {
    "" Split navigations
	nnoremap <C-J> <C-W><C-J> " move to the split below
	nnoremap <C-K> <C-W><C-K> " move to the split above
	nnoremap <C-L> <C-W><C-L> " move to the split to the right
	nnoremap <C-H> <C-W><C-H> " move to the split to the left
	"" More natural split opening
	"" Open new split panes to right and bottom, which feels more natural than default Vim behaviour.

	set splitbelow
	set splitright
	let g:netrw_altv = 1 " when navigating a folder,
						 " hitting <v> opens a window at right side (default
						 " is left side)

	"" Code folding options
	"nnoremap <leader>f0 :set foldlevel=0<CR>
	"nnoremap <leader>f1 :set foldlevel=1<CR>
	"nnoremap <leader>f2 :set foldlevel=2<CR>
	"nnoremap <leader>f3 :set foldlevel=3<CR>
	"nnoremap <leader>f4 :set foldlevel=4<CR>
	"nnoremap <leader>f5 :set foldlevel=5<CR>
	"nnoremap <leader>f6 :set foldlevel=6<CR>
	"nnoremap <leader>f7 :set foldlevel=7<CR>
	""use space to open folds
	"nnoremap <space> za 
    " zo : open a fold
    " zc : close a fold

	"" Shortcuts
	"" Change Working Directory to that of the current file
	cnoremap cwd lcd %:p:h
	cnoremap cd. lcd %:p:h

	"" Visual shifting (does not exit Visual mode)
"	vnoremap < <gv
"	vnoremap > >gv

	"" Allow using the repeat operator with a visual selection (!)
	"" http://stackoverflow.com/a/8064607/127816
	vnoremap . :normal .<CR>

	"" Adjust viewports to the same size
"	noremap <Leader>= <C-w>=

	"" Easier horizontal scrolling
	"ap zl zL
	"ap zh zH

	"" Remove trailing ^M (mswindows ff)
	nnoremap <Leader>rdos :%s/\r//g

	""!! trailing whitespace removal
	nnoremap <Leader>rtw :%s/\s\+$//e<CR>

"	nnoremap <Leader>n :call NumberToggle()<cr>
	""!! searching shortcuts
"	nnoremap <Leader>sh :set hlsearch!<CR>
"	nnoremap <Leader>cs :let @/ = ""<CR>
"	nnoremap <Leader>* :let curwd='\<<C-R>=expand("<cword>")<CR>\>'<CR>:let @/=curwd<CR>:call histadd("search", curwd)<CR>

	"" FIXME: Revert this f70be548
	"" fullscreen mode for GVIM and Terminal, need 'wmctrl' in you PATH
"	noremap <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>

	"" some key bindings for tabs
	"" [Ctrl]+T plus a directional arrow to go to the tab:
	""     up: to go to the first tab
	""   down: to got to the last
	""   left: to go to the previous tab.
	""  right: to go to the next tab.
"	noremap <C-t><up> :tabr<cr>
"	noremap <C-t><down> :tabl<cr>
"	noremap <C-t><left> :tabp<cr>
"	noremap <C-t><right> :tabn<cr>

	"" EasyAlign maps
	"" Start interactive EasyAlign in visual mode (e.g. vipga)
"	xmap ga <Plug>(EasyAlign)

	"" Start interactive EasyAlign for a motion/text object (e.g. gaip)
"	nmap ga <Plug>(EasyAlign)

	"" Ctrl + d to delete a line
"	nnoremap <C-d> dd
"	inoremap <C-d> <esc>ddi

	"" Ctrl + u to toggle word's case (uppercase <-> lowercase)
"	nnoremap <C-u> g~iw
	"" Edit my vimrc file in split window
"	nnoremap <leader>ev :vsplit $MYVIMRC<CR>
	"" Source my vimrc file in split window
"	nnoremap <leader>sv :source $MYVIMRC<CR>
    "" Source Vim configuration file and clean up plugins
"    nnoremap <silent><leader>pcc :source $MYVIMRC \| :PlugClean<CR>
"    "" Source Vim configuration file and install plugins
"    nnoremap <silent><leader>pin :source $MYVIMRC \| :PlugInstall<CR>
    "" Source Vim configuration file and update plugins
"    nnoremap <silent><leader>pup :source $MYVIMRC \| :PlugUpdate<CR>
    "" Source Vim configuration file and upgrade vim-plug itself
"    nnoremap <silent><leader>pug :source $MYVIMRC \| :PlugUpgrade<CR>

	"" enable horizontal scrollbar when nowrap
	"nnoremap <silent><expr> <f2> ':set wrap! go'.'-+'[&wrap]."=b\r"
""" } Key (re)Mappings
