""" Autocmd [au], Augroup [aug] {
	" Commenting blocks of code.
	aug CodeComments
		au FileType c,cpp,java,cs,scala let b:comment_leader = '// '
		au FileType sh,ruby,python   let b:comment_leader = '# '
		au FileType conf,fstab       let b:comment_leader = '# '
		au FileType tex              let b:comment_leader = '% '
		au FileType mail             let b:comment_leader = '> '
		au FileType vim              let b:comment_leader = '" '
		au FileType bat,cmd          let b:comment_leader = ':: '
		au FileType ini              let b:comment_leader = '; '
	aug end

	noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
	noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

	"-----------------------------------------------------------------------------
	" Execution commands
	"
	au FileType python nnoremap <leader>ex :!python %<CR>
	au FileType ruby nnoremap <leader>ex :!ruby %<CR>
	au FileType cpp nnoremap <leader>ex :!g++ --std=c++11 -o %.out % && ./%.out && rm %.out<CR>

    " set git commit msg to 72 columns
    autocmd Filetype gitcommit setlocal spell textwidth=72
	"-----------------------------------------------------------------------------
	" Execution commands
	"
	aug ExecutionCmds
		au FileType python nnoremap <leader>ex :!python %<CR>
		au FileType ruby nnoremap <leader>ex :!ruby %<CR>
		au FileType cpp nnoremap <leader>ex :!g++ --std=c++11 -o %.out % && ./%.out && rm %.out<CR>
	aug end

	" only show relative numbers in normal mode
	autocmd InsertEnter * :set norelativenumber
	autocmd InsertLeave * :set relativenumber

	" don't show relative numbers when out of focus
	au FocusLost * :set norelativenumber
	au FocusGained * :set relativenumber

""" } au, aug
