" plugin_ycm.vim
"

if g:ycm_enabled
    let g:ycm_register_as_syntastic_checker = 0 "default 1
    let g:Show_diagnostics_ui = 1 "default 1
    "
    "" will put icons in Vim's gutter on lines that have a diagnostic set.
    "" Turning this off will also turn off the YcmErrorLine and YcmWarningLine highlighting
    let g:ycm_enable_diagnostic_signs = 1
    let g:ycm_enable_diagnostic_highlighting = 0
    let g:ycm_always_populate_location_list = 1 "default 0
    let g:ycm_open_loclist_on_ycm_diags = 1 "default 1
    let g:ycm_error_symbol = '\u274C' "" '>>'
    let g:ycm_warning_symbol = '\u2757' "'!!'
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
endif    
