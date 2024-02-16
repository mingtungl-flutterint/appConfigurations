" plugin_syntastic.vim
"

if g:syntastic_enabled
    "set statusline=[%n]\ %<%F\ \ \ [%M%R%H%W%Y][%{&ff}]\ \ %=\ line:%l/%L\ col:%c\ \ \ %p%%\ \ \ @%{strftime(\"%H:%M:%S\")}    
    "" Broken down into easily includeable segments
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
else
    let g:syntastic_mode_map = {
        \ 'mode': 'passive', 
        \ 'active_filetypes': [],
        \ 'passive_filetypes': ['lua', 'python', 'sh', 'zsh', 'cpp', 'json']
        \ }
    " SyntasticToggleMode
endif
