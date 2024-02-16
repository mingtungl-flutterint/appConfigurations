" airline_settings.vim
"

if g:airline_enabled
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    
    let g:airline_powerline_fonts=1
    let g:Powerline_symbols = 'fancy'
    "" powerline symbols
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

    " Section A: displays the mode + additional flags like crypt/spell/paste (INSERT)
    let g:airline_section_a = airline#section#create_left(['mode','spell','branch'])  " test
    "let g:airline_section_a = airline#section#create(['mode','|','spell','|','branch'])  " test

    " Section B: Environment status (VCS information - branch, hunk summary (master), battery level)
    "let g:airline_section_b = '%{strftime("%c")}'
    let g:airline_section_b = airline#section#create_left(['ffenc','hunks','%{strftime("%c")}'])  " test 

    " Section C: filename + read-only flag (~/.vim/vimrc RO)
    "let g:airline_section_c = airline#section#create(['%f'])  " test

    " Section X: filetype (vim)
    "let g:airline_section_x = ''
    let g:airline_section_x = airline#section#create(['%y','|','%P'])  " test

    " Section Y: file encoding[fileformat] (utf-8[unix])
    "let g:airline_section_y = 'BN: %{bufnr("%")}'
    let g:airline_section_y = airline#section#create(['%B'])  " test

    " Section Z: current position in the file
    "" set the CN (column number) symbol:
    "let g:airline_section_z = airline#section#create(["\uE0A1" . '%{line(".")}' . "\uE0A3" . '%{col(".")}'])

    " Display the statusline in the tabline (first top line):
    let g:airline_statusline_ontop = 0
    " Display a short path in statusline:
    "let g:airline_stl_path_style = 'short'

    "let g:airline_theme = "srcery"
    let g:airline_theme="papercolor"
    "let g:airline_theme="onedark"
    let g:airline_skip_empty_sections = 1
    hi link SyntasticError YCMerror
    hi link SyntasticWarning YCMwarn
endif
