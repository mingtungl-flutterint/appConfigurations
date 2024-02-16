" plugin_nerdcommenter.vim
"

"" NerdCommenter {
" Most of the following mappings are for normal/visual mode only. The |NERDCommenterInsert| mapping is for insert mode only.
"     [count]<leader>cc |NERDCommenterComment|: Comment out the current line or text selected in visual mode.
"     [count]<leader>cn |NERDCommenterNested|: Same as cc but forces nesting.
"     [count]<leader>c<space> |NERDCommenterToggle|: Toggles the comment state of the selected line(s). If the topmost selected line is commented, all selected lines are uncommented and vice versa.
"     [count]<leader>ci |NERDCommenterInvert|: Toggles the comment state of the selected line(s) individually.
"     [count]<leader>cs |NERDCommenterSexy|: Comments out the selected lines with a pretty block formatted layout.
"     [count]<leader>cu |NERDCommenterUncomment|: Uncomments the selected line(s).

if g:nerdcommenter_enabled
    "" Add spaces after comment delimiters by default
    let g:NERDSpaceDelims = 1

    "" Use compact syntax for prettified multi-line comments
    let g:NERDCompactSexyComs = 1

    "" Align line-wise comment delimiters flush left instead of following code indentation
    let g:NERDDefaultAlign = 'left'

    " Set a language to use its alternate delimiters by default
    let g:NERDAltDelims_java = 1

    "" Add your own custom formats or override the defaults
    let g:NERDCustomDelimiters = { 'h': { 'left': '/**','right': '*/' } }
    let g:NERDCustomDelimiters = { 'hpp': { 'left': '//','right': '' } }
    let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
    let g:NERDCustomDelimiters = { 'cpp': { 'left': '//','right': '' } }
    let g:NERDCustomDelimiters = { 'c++': { 'left': '//','right': '' } }
    let g:NERDCustomDelimiters = { 'C': { 'left': '//','right': '' } }

    "" Allow commenting and inverting empty lines (useful when commenting a region)
    let g:NERDCommentEmptyLines = 1

    "" Enable trimming of trailing whitespace when uncommenting
    let g:NERDTrimTrailingWhitespace = 1

    "" Enable NERDCommenterToggle to check all selected lines is commented or not 
    let g:NERDToggleCheckAllLines = 1
endif
