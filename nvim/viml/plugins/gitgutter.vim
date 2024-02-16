" plugin_gitgutter.vim
"

"" git-gutter {
" To turn off signs by default:
"   let g:gitgutter_signs = 0
" To turn on line highlighting by default
"   let g:gitgutter_highlight_lines = 1
if g:gitgutter_enabled
    let g:gitgutter_sign_added = '+'
    let g:gitgutter_sign_modified = '~'
    let g:gitgutter_sign_removed = '-'
    let g:gitgutter_sign_removed_first_line = '^'
    let g:gitgutter_sign_modified_removed = '#'

    " Jump between hunks
    nmap <Leader>gn <Plug>GitGutterNextHunk  " git next - jump to next hunk
    nmap <Leader>gp <Plug>GitGutterPrevHunk  " git previous - jump to previous hunk
    " Hunk-add and hunk-revert for chunk staging
    nmap <Leader>ga <Plug>GitGutterStageHunk  " git add - stage the hunk
    nmap <Leader>gu <Plug>GitGutterUndoHunk   " git undo - revert the hunk
    nmap <Leader>gp <Plug>GitGutterPreviewHunk " preview a hunk's changes
    " if WINDOWS()
        " let g:gitgutter_git_executable = 'C:\Program Files\Git\bin\git.exe'
    " endif
endif
