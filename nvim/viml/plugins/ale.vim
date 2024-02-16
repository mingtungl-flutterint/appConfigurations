" plugin_ale.vim
"

if g:ale_enabled
    " let g:ale_completion_enabled = 1
    let g:ale_completion_autoimport = 0
    let g:ale_sign_column_always = 1

    nmap <F9> :ALEInfo<CR>
    nmap <F10> :ALEFix<CR>

    "b:ale_linters =  " enable linters for a single buffer
    "g:ale_linters =  " enable linters globally
    let g:ale_linters = {
    \   'javascript': ['eslint', 'tsserver'],
    \   'jsx': ['stylelint', 'eslint'],
    \   'json': ['jsonlint'],
    \   'typescript': ['eslint', 'tsserver'],
    \   'python': ['flake8', 'pyright' , 'pylint'],
    \   'vim': ['vint'],
    \   'cpp': ['clang', 'ccls', 'cpplint'],
    \   'c': ['clang', 'ccls', 'cpplint']
    \ }
    " Fix Python files with autopep8 and yapf.
    let b:ale_fixers = {
    \   '*': ['remove_trailing_lines', 'trim_whitespace'],
    \   'javascript': ['prettier', 'eslint', 'tsserver'],
    \   'typescript': ['prettier', 'eslint', 'tsserver'],
    \   'python': ['autopep8', 'yapf']
    \ }
    " Disable warnings about trailing whitespace for Python files.
    let b:ale_warn_about_trailing_whitespace = 1

    " Only run linters named in ale_linters settings.
    let g:ale_linters_explicit = 0

    " Specify what text should be used for signs:
    let g:ale_sign_error = '💣'
    let g:ale_sign_warning = '🚩'
    " let g:ale_sign_error = '\u274c'
    " let g:ale_sign_warning = '\u26a0'
    " let g:ale_sign_error = '⨉'
    " let g:ale_sign_warning = '⚠'

    let g:ale_lint_on_text_changed = 'never'
    let g:ale_lint_on_insert_leave = 1
    let g:ale_lint_on_enter = 0
    let g:ale_lint_on_save = 1
    highlight clear ALEErrorSign
    highlight clear ALEWarningSign

    " highlighting
    let g:ale_set_highlights = 0
    highlight ALEWarning ctermbg=DarkMagenta

    let g:ale_python_flake8_options = '--ignore=E129,E501,E302,E265,E241,E305,E402,W503'
    let g:ale_python_pylint_options = '-j 0 --max-line-length=120'
    let g:ale_list_window_size = 4
    let g:ale_open_list = 1
    let g:ale_keep_list_window_open = '1'

    " Format for echo messages
    let g:ale_echo_msg_error_str = 'E'
    let g:ale_echo_msg_warning_str = 'W'
    let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
endif
