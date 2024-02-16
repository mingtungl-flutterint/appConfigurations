" autocmd_settings.vim
""" autocmd [au], augroup [aug] {
	let xml_syntax_folding=1      " XML
	au FileType xml setlocal foldmethod=syntax

    au FileType xslt,xml,css,html,xhtml,docbook set nowrap autoindent shiftwidth=2 softtabstop=2 expandtab
    au FileType javascript,sh,config,h,hpp,c,cpp,java,cs set nowrap autoindent shiftwidth=4 softtabstop=4 expandtab
    au FileType sql,ini,puml set nowrap autoindent shiftwidth=4 softtabstop=4 expandtab
    au FileType tex set wrap shiftwidth=2 softtabstop=2 expandtab autoindent
    au FileType make set nowrap noexpandtab shiftwidth=8 softtabstop=0 autoindent
    au FileType python set nowrap tabstop=4 softtabstop=4 expandtab autoindent shiftwidth=4 cinwords=if,elif,else,for,while,try,except,finally,def,class
    au FileType json syntax match Comment +\/\/.\+$+

    au BufRead,BufNewFile *.tex,*.xml,*.html,*.js,*.java,*.py,*.pyw,*.h,*.c,*.cpp,*.cs,*.hpp set ff=unix

    " Use the below highlight group when displaying bad whitespace is desired.
    highlight BadWhitespace ctermbg=red guibg=red

    " Display tabs at the beginning of a line in Python mode as bad.
    au BufRead,BufNewFile *.tex,*.xml,*.html,*.js,*.java,*.py,*.pyw,*.h,*.c,*.cpp,*.cs,*.hpp match BadWhitespace /^\t\+/

    " Flagging Unnecessary Whitespace so that it’s easy to spot and then remove
    au BufRead,BufNewFile *.tex,*.xml,*.html,*.js,*.java,*.py,*.pyw,*.h,*.c,*.cpp,*.cs,*.hpp match BadWhitespace /\s\+$/

    " Reindent the current file
    " BufWritePre: before write
    au BufWritePre,BufRead *.tex,*.xml,*.html,*.js,*.java,*.py,*.pyw,*.h,*.c,*.cpp,*.cs,*.hpp :normal gg=G

    " Wrap text after a certain number of characters
    "au BufRead,BufNewFile *.py,*.pyw, set textwidth=100

    " For full syntax highlighting:
    let python_highlight_all=1

    "Folding based on indentation:
    au FileType python set foldmethod=indent

	" Commenting line of code.
	aug CodeLineComments
		au FileType c,cpp,java,cs,scala         nnoremap <buffer> <localleader>c I// <esc>
		au FileType sh,ruby,python,fstab,conf   nnoremap <buffer> <localleader>c I# <esc>
		au FileType tex                         nnoremap <buffer> <localleader>c I% <esc>
		au FileType mail                        nnoremap <buffer> <localleader>c I> <esc>
		au FileType vim                         nnoremap <buffer> <localleader>c I" <esc>
		au FileType bat,cmd                     nnoremap <buffer> <localleader>c I:: <esc>
		au FileType ini                         nnoremap <buffer> <localleader>c I; <esc>
		au FileType lua                         nnoremap <buffer> <localleader>c -- <esc>
	aug end

	" Commenting blocks of code.
	aug CodeBlockComments
		au FileType c,cpp,java,cs,scala let b:comment_leader = '// '
		au FileType sh,ruby,python   let b:comment_leader = '# '
		au FileType conf,fstab       let b:comment_leader = '# '
		au FileType tex              let b:comment_leader = '% '
		au FileType mail             let b:comment_leader = '> '
		au FileType vim              let b:comment_leader = '" '
		au FileType bat,cmd          let b:comment_leader = ':: '
		au FileType ini              let b:comment_leader = '; '
	aug end

	noremap <silent><Leader>cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
	noremap <silent><Leader>cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>
    " Comment out selected lines + format them
    vnoremap <silence><Leader>ca :s/^/\=b:comment_leader/g<CR>gv=
    " Uncomment selected lines (copied from StackOverflow = black magic)  + format     them
    vnoremap <silence><Leader>cr :s@\V<c-r>=escape(b:comment_leader,'\@')<cr>@@<cr>gv=

	"-----------------------------------------------------------------------------
    " set git commit msg to 72 columns
    au Filetype gitcommit setlocal spell textwidth=72

	"-----------------------------------------------------------------------------
	" Execution commands
	"
	aug ExecutionCmds
		au FileType python nnoremap <leader>ex :!python %<CR>
		au FileType ruby nnoremap <leader>ex :!ruby %<CR>
		au FileType cpp nnoremap <leader>ex :!g++ --std=c++11 -o %.out % && ./%.out && rm %.out<CR>
	aug end

	" only show relative numbers in normal mode
	au InsertEnter * :set norelativenumber
	au InsertLeave * :set relativenumber

	" don't show relative numbers when out of focus
	au FocusLost * :set norelativenumber
	au FocusGained * :set relativenumber

""" } au, aug
