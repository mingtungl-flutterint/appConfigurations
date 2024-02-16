" common_settings.vim
" Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=syntax :
" }

""" Environment {
	set t_Co=256
	set autoread nobackup nowritebackup noswf
	""!! swapsyn [sws]=sync/fsync/empty -- how to flush a swap file to disk
	"set sws=fsync
	set wildignore=*.o,*.obj,*.bak,*.exe,*.py[co],*.swp,*~,*.pyc,.svn
	""!! make yank copy to the global system clipboard
    if has('nvim')
        set clipboard+=unnamedplus
    else
        set clipboard^=unnamed,unnamedplus
    endif
	set fileencodings=          " Don't do any encoding conversion
""" } Environment

""" General {
	filetype plugin indent on   " Automatically detect file types.
	syntax on                   " Syntax highlighting
	set ff=unix
	set mouse=a                 " Automatically enable mouse usage
	set mousehide               " Hide the mouse cursor while typing
	scriptencoding utf-8

    set formatoptions-=a    " Auto formatting is BAD.
    set formatoptions-=t    " Don't auto format my code. I got linters for that.
    set formatoptions+=c    " In general, I like it when comments respect textwidth
    set formatoptions+=q    " Allow formatting comments w/ gq
    set formatoptions-=o    " O and o, don't continue comments
    set formatoptions+=r    " But do continue when pressing enter.
    set formatoptions+=n    " Indent past the formatlistpat, not underneath it.
    set formatoptions+=j    " Auto-remove comments if possible.
    set formatoptions-=2    " I'm not in gradeschool anymore

	"set autowrite                       " Automatically write a file when leaving a modified buffer
	"set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
	"set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
	set virtualedit=onemore             " Allow for cursor beyond last character
	"set history=1000                    " Store a ton of history (default is 20)
	set spell                           " Spell checking on
	set hidden cindent title
	"set ruler rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)

	set backspace=indent,eol,start  " Backspace for dummies
	set linespace=0                 " No extra spaces between rows

	set noshowcmd showmatch wildmenu wildmode=list:longest,full
	"set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
	set scrolljump=5                " Lines to scroll when cursor leaves screen
	set scrolloff=2                 " Minimum lines to keep above and below cursor
	set nofoldenable                " No Auto fold code
	set foldmethod=syntax
	"set foldlevel=2
	set foldnestmax=10
	set winminheight=0              " Windows can be 0 line high
    "set list lcs=trail:·,tab:→·,extends:…,precedes:…,nbsp:⣿
    "set list lcs=trail:·,tab:»·,extends:…,precedes:…,nbsp:⣿

	""-----------------------------------------------------------------------------
	""!! Status lines
	if has('statusline')
		set laststatus=2
		set matchtime=2         " show matching bracket for 0.2 seconds
		""!! Broken down into easily includeable segments
		set statusline=%<%f\                     " Filename
		set statusline+=%w%h%m%r                 " Options
		"set statusline+=%{fugitive#statusline()} " Git Hotness
		set statusline+=\ [%{&ff}/%Y]            " Filetype
		set statusline+=\ [%{getcwd()}]          " Current dir
		set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
	endif

	""-----------------------------------------------------------------------------
	""!! Numbering
	set number relativenumber

	""-----------------------------------------------------------------------------
	""!! Searching
	set incsearch                   " Find as you type search
	set hlsearch                    " Highlight search terms
	set ignorecase                  " Case insensitive search
	set smartcase                   " Case sensitive when uc present

	""-----------------------------------------------------------------------------
	""!! mark trailing whitespace
	highlight ExtraWhitespace ctermbg=red guibg=red
	match ExtraWhitespace /\s\+$/
	autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
	autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
	autocmd InsertLeave * match ExtraWhitespace /\s\+$/
	autocmd BufWinLeave * call clearmatches()

""" } General

""" Formatting {
	set nowrap                      " Do not wrap long lines
	set autoindent                  " Indent at the same level of the previous line
	set shiftwidth=4                " Use indents of 4 spaces
	set expandtab                   " Tabs are spaces, not tabs
	set tabstop=4                   " An indentation every four columns
	set softtabstop=4               " Let backspace delete indent
	set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
	"set splitright                  " Puts new vsplit windows to the right of the current
	"set splitbelow                  " Puts new split windows to the bottom of the current
	set matchpairs+=<:>             " Match, to be used with %
	set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)

""" } Formatting 

""" Vim UI {
	set background=dark
	"set background=light
    
    " Terminal: vim uses the same font as terminal
    " GUI (nvim-qt, gVim, etc.): set GuiFont! <font name:size:cAnsi> in ginit.vim

	"if !has('gui')
	"    set term=$TERM          " Make arrow and other keys work
	"endif

	if has( "termguicolors" )
		set termguicolors
		hi Cursor guifg=green guibg=green
		hi Cursor2 guifg=red guibg=red
		set guicursor=n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor50
	endif

	"colorscheme solarized
	"let g:solarized_termcolors=256
	"let g:solarized_termtrans=1
	"let g:solarized_contrast="high"
	"let g:solarized_visibility="high"

	""!! srcery colorscheme settings
	"let g:srcery_italic = 1
	"colorscheme srcery
	"colorscheme onedark

	""!! PaperColor colorscheme settings
	colorscheme PaperColor

	set tabpagemax=15               " Only show 15 tabs
	set noshowmode                    " Display the current mode

	"if has('cmdline_info')
	"	set ruler                   " Show the ruler
	"	set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
	"	set showcmd                 " Show partial commands in status line and
		""!! Selected characters/lines in visual mode
	"endif

	set cursorline                  " Highlight current line
	highlight clear SignColumn      " SignColumn should match background
	highlight clear LineNr          " Current line number row will have same background color in relative mode
	highlight clear CursorLineNr    " Remove highlight color from current line number
	"hi CursorLine guibg=bg guifg=fg
    "!! Reset to default color: set to NONE
    "hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
	"autocmd InsertEnter * highlight CursorLine guibg=bg guifg=fg
	"autocmd InsertLeave * highlight CursorLine guibg=bg guifg=fg
	autocmd InsertEnter * highlight CursorLine guibg=#626262 guifg=NONE
	autocmd InsertEnter * highlight CursorLine guibg=#000050 guifg=fg
	autocmd InsertLeave * highlight CursorLine guibg=#004000 guifg=NONE

	""!! Show cursorline only in active window
	"augroup CursorLine
	"	autocmd!
	"	autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
	"	autocmd WinLeave * setlocal nocursorline
	"augroup END 

	"-- show colorcolumn in insert mode
	hi ColorColumn cterm=NONE ctermbg=black guibg=lightgreen
	""!! set color column only in insert mode
	augroup ColorColumn
		autocmd!
		autocmd InsertEnter * setlocal colorcolumn=150
		autocmd InsertLeave * setlocal colorcolumn=0
	augroup END 

	""!! with www/xxx three digit colors taken from this palette 
	""!! https://upload.wikimedia.org/wikipedia/en/1/15/Xterm_256color_chart.svg
	""!! and #yyyyyy/#zzzzzz
	"hi SpellBad ctermfg=009 ctermbg=009 guifg=#ff0000 guibg=#ff0000
	"hi SpellCap ctermfg=011 ctermbg=011 guifg=#ffff00 guibg=#ffff00
	hi YCMerror term=reverse cterm=reverse ctermfg=230 ctermbg=235 guifg=Red
	hi YCMwarn term=reverse cterm=reverse ctermfg=230 ctermbg=235 guifg=Yellow

""" } Vim UI
