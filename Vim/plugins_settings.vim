""" Plugins {
	" YCM {
		if g:ycm_enabled
		"if exists('g:ycm_enabled')
			" { 
			"" YouCompleteMe options
			"
			let g:ycm_register_as_syntastic_checker = 0 "default 1
			let g:Show_diagnostics_ui = 1 "default 1
			"
			""will put icons in Vim's gutter on lines that have a diagnostic set.
			"Turning this off will also turn off the YcmErrorLine and YcmWarningLine
			""highlighting
			let g:ycm_enable_diagnostic_signs = 1
			let g:ycm_enable_diagnostic_highlighting = 0
			let g:ycm_always_populate_location_list = 1 "default 0
			let g:ycm_open_loclist_on_ycm_diags = 1 "default 1
			let g:ycm_error_symbol = '>>'
			let g:ycm_warning_symbol = '!!'
			"" When set to  1 , the OmniSharp server will be automatically started 
			"" or stopped (once per Vim session) when you open a C# file.
			let g:ycm_auto_start_csharp_server = 1
			let g:ycm_auto_stop_csharp_server = 1
			let g:ycm_min_num_of_chars_for_completion = 1
			let g:ycm_cache_omnifunc = 0
			let g:ycm_seed_identifiers_with_syntax = 1
			let g:ycm_complete_in_comments = 1
			let g:ycm_complete_in_strings = 1
			let g:ycm_collect_identifiers_from_tags_files = 1
			let g:ycm_path_to_python_interpreter = '' "default ''

			let g:ycm_server_use_vim_stdout = 0 "default 0 (logging to console)
			let g:ycm_server_log_level = 'info' "default info
			let g:ycm_extra_conf_vim_data = ['&filetype'] 
			let g:ycm_global_ycm_extra_conf = '$HOME/.ycm_extra_conf.py'  "where to search for .ycm_extra_conf.py if not found
			let g:ycm_confirm_extra_conf = 0 "no annoying tips on vim starting

			let g:ycm_goto_buffer_command = 'same-buffer' "[ 'same-buffer', 'horizontal-split', 'vertical-split', 'new-tab' ]
			let g:ycm_filetype_whitelist = { '*': 1 }
			let g:ycm_key_invoke_completion = '<C-Space>'
			
			let g:ycm_collect_identifiers_from_comments_and_strings = 0
			let g:ycm_filetype_blacklist = {'tex' : 1, 'markdown' : 1, 'text' : 1, 'html' : 1}
			let g:syntastic_ignore_files = [".*\.py$"] "python has its own check engine
			"let g:ycm_semantic_triggers = {}
			"let g:ycm_semantic_triggers.c = ['->', '.', ' ', '(', '[', '&']
			"set completeopt = longest,menu
			autocmd InsertLeave * if pumvisible() == 0|pclose|endif
			nmap <leader>gd :YcmDiags<CR>
			nnoremap <leader>gl :YcmCompleter GoToDeclaration<CR>
			nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
			nnoremap <leader>gg :YcmCompleter GoToDefinitionElseDeclaration<CR>
			nnoremap <F11> :YcmForceCompileAndDiagnostics <CR>
			" }
		endif    
	" } YCM

	" OmniComplete {
		""" To disable omni complete, add the following to .vimrc.before file:
		"""   let g:omni_complete = 0
		if g:omni_complete_enabled
		"if exists('g:omni_complete_enable')
			if has("autocmd") && exists("+omnifunc")
				autocmd Filetype *
					\if &omnifunc == "" |
					\setlocal omnifunc=syntaxcomplete#Complete |
					\endif
			endif

			hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
			hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
			hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

			" Some convenient mappings
			inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
			inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
			inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
			inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
			inoremap <expr> <C-d>      pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
			inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

			" Automatically open and close the popup menu / preview window
			au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
			set completeopt=menu,preview,longest
		endif
	" } OmniComplete

	" Crtl-P {
		if g:ctrlp_enabled
			let g:ctrlp_map = '<c-p>'
			let g:ctrlp_working_path_mode = 'ra'
			set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
			"set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

			" let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
			let g:ctrlp_custom_ignore = {
					 \ 'dir':  '\v[\/]\.(git|hg|svn)$',
					 \ 'file': '\v\.(exe|so|dll)$',
					 \ 'link': 'some_bad_symbolic_links',
					 \ }
			let g:ctrlp_user_command = 'find %s -type f'        " MacOSX/Linux
			let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d'  " Windows

			let g:ctrlp_working_path_mode = 'ra'
			nnoremap <silent> <D-t> :CtrlP<CR>
			nnoremap <silent> <D-r> :CtrlPMRU<CR>

			" On Windows use "dir" as fallback command.
			if WINDOWS()
				let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
			elseif executable('ag')
				let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
			elseif executable('ack')
				let s:ctrlp_fallback = 'ack %s --nocolor -f'
			else
				let s:ctrlp_fallback = 'find %s -type f'
			endif
		endif    
	" } ctrlp

	" Ctags {
		set tags=./tags;/,~/.vimtags
		"set tags+=$HOME/core.tags
		"autocmd FileType c,cpp,h,hpp setlocal tags=$HOME/tags-core,./tags;/,tags;/

		" Make tags placed in .git/tags file available in all levels of a repository
		let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
		if gitroot != ''
			let &tags = &tags . ',' . gitroot . '/.git/tags'
		endif
	" } Ctags

		" easy-tag
		" Tell EasyTags to use the tags file found by Vim
		""let g:easytags_dynamic_files = 1
		"let g:easytags_cmd='C:\Windows\ctags.exe' """"'$VIMRUNTIME\ctags.exe'
		"let g:easytags_opts=['--options=--c++-kinds=+defgmnpstux --languages= --languages=+c,c++ --fields=+iaS --extra=+q']

	" Airline {
		if g:airline_enabled
			if !exists('g:airline_symbols')
				let g:airline_symbols = {}
			endif
			
			let g:airline_powerline_fonts=1
			let g:Powerline_symbols = 'fancy'
            " powerline symbols
            "let g:airline_left_sep = ''
            "let g:airline_left_alt_sep = ''
            "let g:airline_right_sep = ''
            "let g:airline_right_alt_sep = ''
            let g:airline_left_sep = "\ue0b0"
            "let g:airline_left_alt_sep = "\ue0b0"
            let g:airline_right_sep = "\ue0b2"
            "let g:airline_right_alt_sep = "\ue0b2"
            let g:airline_symbols.branch = ''
            let g:airline_symbols.readonly = ''
            let g:airline_symbols.linenr = '☰'
            let g:airline_symbols.maxlinenr = ''
			let g:airline_section_b = '%{strftime("%c")}'
			let g:airline_section_x = ''
			let g:airline_section_y = 'BN: %{bufnr("%")}'
            " set the CN (column number) symbol:
            let g:airline_section_z = airline#section#create(["\uE0A1" . '%{line(".")}' . "\uE0A3" . '%{col(".")}'])
			let g:airline_powerline_fonts = 1
			"let g:airline_theme = "srcery"
			let g:airline_theme="papercolor"
			"let g:airline_theme="onedark"
            let g:airline_skip_empty_sections = 1
			hi link SyntasticError YCMerror
			hi link SyntasticWarning YCMwarn
		endif
	" } Airline

	" AutoCloseTag {
		if g:autoclosetag_enabled
			" Make it so AutoCloseTag works for xml and xhtml files as well
			au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
			nmap <Leader>ac <Plug>ToggleAutoCloseMappings
		endif
	" } AutoCloseTag 

	" syntastic {
		if g:syntastic_enabled
			"set statusline=[%n]\ %<%F\ \ \ [%M%R%H%W%Y][%{&ff}]\ \ %=\ line:%l/%L\ col:%c\ \ \ %p%%\ \ \ @%{strftime(\"%H:%M:%S\")}    
			" Broken down into easily includeable segments
			set statusline=%<%f\                     " Filename
			set statusline+=%w%h%m%r                 " Options
			set statusline+=\ [%{&ff}/%Y]            " Filetype
			set statusline+=\ [%{getcwd()}]          " Current dir
			set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
			set statusline+=%#warningmsg#
			set statusline+=%{SyntasticStatuslineFlag()}
			set statusline+=%*

			let g:syntastic_always_populate_loc_list = 1
			let g:syntastic_auto_loc_list = 1
			let g:syntastic_check_on_open = 1
			let g:syntastic_enable_signs=1
			let g:syntastic_check_on_wq = 0

			let g:syntastic_error_symbol = "X"
			let g:syntastic_warning_symbol = "!"
			let g:syntastic_style_error_symbol = "X"
			let g:syntastic_style_warning_symbol = "!"
			"" whether to show balloons
			let g:syntastic_enable_balloons = 1
			
			let g:syntastic_cs_checkers = ['mcs']
			let g:syntastic_cs_check_header = 1
			let g:syntastic_cs_errorformat = '%f:%l:%c: %trror: %m'
			let g:syntastic_cs_compiler = 'mcs'
			let g:syntastic_cs_compiler_options = ' -v -g'

			"let g:syntastic_cpp_compiler = 'clang++'
			"let g:syntastic_cpp_compiler_options = '-std=c++11 -stdlib=libstdc++'
			let g:syntastic_cpp_checkers = ['gcc']
			let g:syntastic_cpp_check_header = 1
			let g:syntastic_cpp_errorformat = '%f:%l:%c: %trror: %m'
			let g:syntastic_c_compiler = 'gcc'
			let g:syntastic_c_compiler_options = ' -ansi -pedantic'
			let g:syntastic_cpp_compiler = "g++"
			let g:syntastic_cpp_compiler_options = "-stdlib=libstdc++ -std=c++11 -Wall -Wextra -Wpedantic"

			let g:syntastic_python_python_exec = '/usr/bin/python3'
		endif
	" } syntastic 


	" NCM2 {
		if g:ncm2_enabled
			augroup NCM2
			  autocmd!
			  " enable ncm2 for all buffers
			  autocmd BufEnter * call ncm2#enable_for_buffer()
			  " :help Ncm2PopupOpen for more information
			  set completeopt=noinsert,menuone,noselect
			  " When the <Enter> key is pressed while the popup menu is visible, it only
			  " hides the menu. Use this mapping to close the menu and also start a new line.
			  inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
			  " uncomment this block if you use vimtex for LaTex
			  " autocmd Filetype tex call ncm2#register_source({
			  "           \ 'name': 'vimtex',
			  "           \ 'priority': 8,
			  "           \ 'scope': ['tex'],
			  "           \ 'mark': 'tex',
			  "           \ 'word_pattern': '\w+',
			  "           \ 'complete_pattern': g:vimtex#re#ncm2,
			  "           \ 'on_complete': ['ncm2#on_complete#omni', 'vimtex#complete#omnifunc'],
			  "           \ })
			augroup END
		endif
	"} NCM2

	" NerdTree {
		if g:nerdtree_enabled
			map <C-n> :NERDTreeToggle<CR>
			"let NERDTreeMapOpenInTab='<ENTER>'
			let g:NERDTreeDirArrowExpandable = '▸'
			let g:NERDTreeDirArrowCollapsible = '▾'
			" open a NERDTree automatically when vim starts up
			"autocmd vimenter * NERDTree
			" open a NERDTree automatically when vim starts up if no files were specified
			"autocmd StdinReadPre * let s:std_in=1
			"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
			" open NERDTree automatically when vim starts up on opening a directory
			"autocmd StdinReadPre * let s:std_in=1
			"autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
			" close vim if the only window left open is a NERDTree
			"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
		endif
	" } NerdTree

	" NerdCommenter {
		if g:nerdcommenter_enabled
			" Add spaces after comment delimiters by default
			let g:NERDSpaceDelims = 1

			" Use compact syntax for prettified multi-line comments
			let g:NERDCompactSexyComs = 1

			" Align line-wise comment delimiters flush left instead of following code indentation
			let g:NERDDefaultAlign = 'left'

			" Set a language to use its alternate delimiters by default
			let g:NERDAltDelims_java = 1

			" Add your own custom formats or override the defaults
			let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
			let g:NERDCustomDelimiters = { 'cpp': { 'left': '//','right': '' } }
			let g:NERDCustomDelimiters = { 'c++': { 'left': '//','right': '' } }
			let g:NERDCustomDelimiters = { 'C': { 'left': '//','right': '' } }

			" Allow commenting and inverting empty lines (useful when commenting a region)
			let g:NERDCommentEmptyLines = 1

			" Enable trimming of trailing whitespace when uncommenting
			let g:NERDTrimTrailingWhitespace = 1

			" Enable NERDCommenterToggle to check all selected lines is commented or not 
			let g:NERDToggleCheckAllLines = 1
		endif
	" } NerdCommenter

	" vim-cpp-enhanced-highlight {
		if g:cpp_enhanced_highlight_enabled
			" Highlighting of class scope is disabled by default. To enable set
			let g:cpp_class_scope_highlight = 1
			" Highlighting of member variables is disabled by default. To enable set
			let g:cpp_member_variable_highlight = 1
			"Highlighting of class names in declarations is disabled by default. To enable set
			let g:cpp_class_decl_highlight = 1
			"There are two ways to highlight template functions. Either
			let g:cpp_experimental_simple_template_highlight = 1
			"which works in most cases, but can be a little slow on large files. Alternatively set
			let g:cpp_experimental_template_highlight = 1
			"which is a faster implementation but has some corner cases where it doesn't work.
			"Note: C++ template syntax is notoriously difficult to parse, so don't expect this feature to be perfect.
			"Highlighting of library concepts is enabled by
			let g:cpp_concepts_highlight = 1
			"This will highlight the keywords concept and requires as well as all named requirements (like DefaultConstructible) in the standard library.
			"Highlighting of user defined functions can be disabled by
			let g:cpp_no_function_highlight = 1
		endif
	" } vim-cpp-enhanced-highlight

	""" Tabular {
		if g:tabular_enabled
			let g:tabular_loaded = 1

			"" Tabular mappings
			if exists(":Tabularize")
				nnoremap <leader>Tab :Tabularize /
				vnoremap <leader>Tab :Tabularize /
				nnoremap <leader>Tab= :Tabularize /=<CR>
				vnoremap <leader>Tab= :Tabularize /=<CR>
				"nnoremap <leader>Tab| :Tabularize / |<CR>
				""vnoremap <leader>Tab| :Tabularize /|\zs/l0r1<CR>
			endif

			function! s:align()
			  let p = '^\s*|\s.*\s|\s*$'
			  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
				let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
				let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
				Tabularize/|/l1
				normal! 0
				call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
			  endif
			endfunction
		endif
		""" }

	" source autotag when reading/writing c++ files
		"autocmd FileType c,cpp,C,c++,h,hpp, source autotag.vim
		
""" } Plugins
