" Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=syntax :
" }

""" Environment {
	set t_Co=256
	" Disable stupid backup and swap files - they trigger too many events
	" for file system watchers
	set nobackup
	set nowritebackup
	set autoread
	"set noswapfile "" IMPORTANT: comment this line if you are working on a remote host
	set wildignore=*.o,*.obj,*.bak,*.exe,*.py[co],*.swp,*~,*.pyc,.svn
	" make yank copy to the global system clipboard
	set clipboard=unnamed
	set fileencodings=          " Don't do any encoding conversion
	" swapfile	use a swap file for this buffer (local to buffer)
	set noswf
	" swapsync	"sync", "fsync" or empty; how to flush a swap file to disk
	"
	"set sws=fsync
""" } Environment

""" General {
	filetype plugin indent on   " Automatically detect file types.
	set ff=unix
	syntax on                   " Syntax highlighting
	set mouse=a                 " Automatically enable mouse usage
	set mousehide               " Hide the mouse cursor while typing
	scriptencoding utf-8

	"set autowrite                       " Automatically write a file when leaving a modified buffer
	set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
	set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
	set virtualedit=onemore             " Allow for cursor beyond last character
	set history=1000                    " Store a ton of history (default is 20)
	set spell                           " Spell checking on
	set hidden                          " Allow buffer switching without saving
	set cindent
	set title

	set noshowmode                    " Display the current mode

	set ruler                   " Show the ruler
	set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
	set showcmd                 " Show partial commands in status line and

	set backspace=indent,eol,start  " Backspace for dummies
	set linespace=0                 " No extra spaces between rows

	set showmatch                   " Show matching brackets/parenthesis
	set wildmenu                    " Show list instead of just completing
	set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
	"set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
	set scrolljump=5                " Lines to scroll when cursor leaves screen
	set scrolloff=2                 " Minimum lines to keep above and below cursor
	set nofoldenable                " No Auto fold code
	set foldmethod=syntax
	"set foldlevel=2
	set foldnestmax=10
	set winminheight=0              " Windows can be 0 line high
	set nolist
	"set listchars=tab:â€º\ ,trail:â€¢,extends:#,nbsp:. " Highlight problematic whitespace

	" set Leader
	let mapleader = ','

	"-----------------------------------------------------------------------------
	" Status lines
	if has('statusline')
		set laststatus=2
		set matchtime=2         " show matching bracket for 0.2 seconds
		" Broken down into easily includeable segments
		set statusline=%<%f\                     " Filename
		set statusline+=%w%h%m%r                 " Options
		"set statusline+=%{fugitive#statusline()} " Git Hotness
		set statusline+=\ [%{&ff}/%Y]            " Filetype
		set statusline+=\ [%{getcwd()}]          " Current dir
		set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
	endif

	"-----------------------------------------------------------------------------
	" Numbering
	"
	set number
	set relativenumber

	" fast toggling
	function! NumberToggle()
	  if(&relativenumber == 1)
		set norelativenumber
	  else
		set relativenumber
	  endif
	endfunc

	nnoremap <Leader>n :call NumberToggle()<cr>

	"-----------------------------------------------------------------------------
	"" Searching
	"
	set incsearch                   " Find as you type search
	set hlsearch                    " Highlight search terms
	set ignorecase                  " Case insensitive search
	set smartcase                   " Case sensitive when uc present
	" searching shortcuts
	nnoremap <Leader>sh :set hlsearch!<CR>
	nnoremap <Leader>cs :let @/ = ""<CR>
	nnoremap <Leader>* :let curwd='\<<C-R>=expand("<cword>")<CR>\>'<CR>:let @/=curwd<CR>:call histadd("search", curwd)<CR>


	"-----------------------------------------------------------------------------
	" mark trailing whitespace
	"
	highlight ExtraWhitespace ctermbg=red guibg=red
	match ExtraWhitespace /\s\+$/
	autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
	autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
	autocmd InsertLeave * match ExtraWhitespace /\s\+$/
	autocmd BufWinLeave * call clearmatches()
	" trailing whitespace removal
	nnoremap <Leader>rtw :%s/\s\+$//e<CR>


""" } General

""" Formatting {
	set nowrap                      " Do not wrap long lines
	set autoindent                  " Indent at the same level of the previous line
	set shiftwidth=4                " Use indents of 4 spaces
	set expandtab                   " Tabs are spaces, not tabs
	set tabstop=4                   " An indentation every four columns
	set softtabstop=4               " Let backspace delete indent
	set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
	set splitright                  " Puts new vsplit windows to the right of the current
	set splitbelow                  " Puts new split windows to the bottom of the current
	set matchpairs+=<:>             " Match, to be used with %
	set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)

	let xml_syntax_folding=1      " XML
	au FileType xml setlocal foldmethod=syntax

	" Put these in an autocmd group, so that we can delete them easily.
	augroup mysettings
		au FileType xslt,xml,css,html,xhtml,docbook set nowrap smartindent shiftwidth=2 softtabstop=2 expandtab
		au FileType javascript,sh,config,h,hpp,c,cpp set nowrap smartindent shiftwidth=4 softtabstop=4 expandtab
		au FileType sql,ini,puml set nowrap smartindent shiftwidth=4 softtabstop=4 expandtab
		au FileType tex set wrap shiftwidth=2 softtabstop=2 expandtab

		"------------Start Python PEP 8 stuff----------------
		" Number of spaces that a pre-existing tab is equal to.
		au BufRead,BufNewFile *py,*pyw,*.c,*.h set tabstop=4

		"spaces for indents
		au BufRead,BufNewFile *.py,*pyw set shiftwidth=4 softtabstop=4 expandtab autoindent ff=unix

		" Use the below highlight group when displaying bad whitespace is desired.
		highlight BadWhitespace ctermbg=red guibg=red

		" Display tabs at the beginning of a line in Python mode as bad.
		au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
		" Flagging Unnecessary Whitespace so that it’s easy to spot and then remove
		au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

		" Wrap text after a certain number of characters
		"au BufRead,BufNewFile *.py,*.pyw, set textwidth=100

		" Use UNIX (\n) line endings.
		au BufNewFile *.py,*.pyw,*.c,*.cpp,*.hpp,*.h set fileformat=unix

		" For full syntax highlighting:
		let python_highlight_all=1

		" Keep indentation level from previous line:
		autocmd FileType python set autoindent

		" make backspaces more powerfull
		set backspace=indent,eol,start

		"Folding based on indentation:
		autocmd FileType python set foldmethod=indent

		"au FileType python set nowrap tabstop=4 softtabstop=4 expandtab shiftwidth=4 cinwords=if,elif,else,for,while,try,except,finally,def,class
		"au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent fileformat=unix
		"----------Stop python PEP 8 stuff--------------

		" in makefiles, don't expand tabs to spaces
		autocmd FileType make set nowrap noexpandtab shiftwidth=8 softtabstop=0

	augroup END

""" } Formatting 

""" Vim UI {
	set background=dark
	"set background=light
    " Uncomment renderoptions to render ligatures in gVim
	set renderoptions=type:directx
	" Set font name:type:size
	"set guifont=Hack:h10:cANSI
	set guifont=FuraCode_NF:h10:cANSI
	"set guifont=DejaVu_Sans_Mono:h10:cANSI
	"set gfn=Cascadia_Code:h10:cANSI
	"set gfn=Fira_Code:h10:cANSI
	"set gfn=Droid_Sans_Mono:h8:cANSI  " regular font

	"if !has('gui')
	"    set term=$TERM          " Make arrow and other keys work
	"endif

	if has( "termguicolors" )
		set termguicolors
		hi Cursor guifg=green guibg=green
		hi Cursor2 guifg=red guibg=red
		set guicursor=n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor50
	endif
	if has( "gui_running" )
		"set guicursor=n-v-c-sm:block,i-ci-ve:block,r-cr-o:blocks
		set lines=48 columns=160
	else
		if exists("+lines")
			set lines=48
		endif
		if exists("+columns")
			set columns=160
		endif
	endif

	if &wrap
		set guioptions-=b
	else
		set guioptions+=b
	endif

	"colorscheme solarized
	"let g:solarized_termcolors=256
	"let g:solarized_termtrans=1
	"let g:solarized_contrast="high"
	"let g:solarized_visibility="high"

	"" Google plugins: https://opensource.google.com/projects/vim-plugins	
	"colorscheme primary  " Google color scheme

	"" srcery colorscheme settings
	"let g:srcery_italic = 1
	"colorscheme srcery
	"colorscheme onedark

	"" PaperColor colorscheme settings
	colorscheme PaperColor
	let g:PaperColor_Theme_Options = {
	    \   'language': {
	    \     'python': {
	    \       'highlight_builtins' : 1
	    \     },
	    \     'cpp': {
	    \       'highlight_standard_library': 1
	    \     },
	    \     'c': {
	    \       'highlight_builtins' : 1
	    \     }
	    \   }
	    \ }

	set tabpagemax=15               " Only show 15 tabs
	set noshowmode                    " Display the current mode

	if has('cmdline_info')
		set ruler                   " Show the ruler
		set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
		set showcmd                 " Show partial commands in status line and
		" Selected characters/lines in visual mode
	endif

	set cursorline                  " Highlight current line
	"highlight clear SignColumn      " SignColumn should match background
	"highlight clear LineNr          " Current line number row will have same background color in relative mode
	"highlight clear CursorLineNr    " Remove highlight color from current line number
	hi CursorLine guibg=bg guifg=fg
	autocmd InsertEnter * highlight CursorLine guibg=bg guifg=fg
	autocmd InsertLeave * highlight CursorLine guibg=bg guifg=fg
	"autocmd InsertEnter * highlight CursorLine guibg=#000050 guifg=fg
	"autocmd InsertLeave * highlight CursorLine guibg=#004000 guifg=fg

	" Show cursorline only in active window
	augroup CursorLineOnlyInActiveWindow
		autocmd!
		autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
		autocmd WinLeave * setlocal nocursorline
	augroup END 

	" show colorcolumn in insert mode: to remind me when my code line is too long or nesting is too deep
	"set colorcolumn=80  " this sets color column at all times
	highlight ColorColumn ctermbg=black
	highlight ColorColumn guibg=lightgreen
	" set color column only in insert mode
	augroup ColorcolumnOnlyInInsertMode
		autocmd!
		autocmd InsertEnter * setlocal colorcolumn=150
		autocmd InsertLeave * setlocal colorcolumn=0
	augroup END 

	"" with www/xxx three digit colors taken from this palette 
	"" https://upload.wikimedia.org/wikipedia/en/1/15/Xterm_256color_chart.svg
	"" and #yyyyyy/#zzzzzz
	"hi SpellBad ctermfg=009 ctermbg=009 guifg=#ff0000 guibg=#ff0000
	"hi SpellCap ctermfg=011 ctermbg=011 guifg=#ffff00 guibg=#ffff00
	hi YCMerror term=reverse cterm=reverse ctermfg=230 ctermbg=235 guifg=Red
	hi YCMwarn term=reverse cterm=reverse ctermfg=230 ctermbg=235 guifg=Yellow

	"" Get buffer width
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

	"" Wrap text at BuferWidth
	function! SoftwrapColumnsToBufSize()
		autocmd!
		autocmd VimResized * | call BufWidth() | setlocal wrap | setlocal linebreak | setlocal showbreak=...
	endfunction

	"augroup softwrapText
	"    autocmd!
	"    autocmd BufRead,BufNewFile *.txt,*.vim,*.ini call SoftwrapColumnsToBufSize()
	"augroup END
""" } Vim UI

