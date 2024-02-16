" plugin_rainbow.vim
"

" vim-rainbow {
if g:rainbow_enabled
    let g:rainbow_active = 1

    let g:rainbow_load_separately = [
        \ [ '*' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
        \ [ '*.tex' , [['(', ')'], ['\[', '\]']] ],
        \ [ '*.cpp' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
        \ [ '*.{html,htm}' , [['(', ')'], ['\[', '\]'], ['{', '}'], ['<\a[^>]*>', '</[^>]*>']] ],
        \ ]

    let g:rainbow_guifgs = ['RoyalBlue3', 'DarkOrange3', 'DarkOrchid3', 'FireBrick']
    let g:rainbow_ctermfgs = ['lightblue', 'lightgreen', 'yellow', 'red', 'magenta']
endif
