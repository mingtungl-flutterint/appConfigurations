" plugin_lsp_settings.vim
"

if g:lsp_enabled
    " Default server location:
    "g:lsp_settings_servers_dir = '$LOCALAPPDATA\vim-lsp-settings\servers'
    "g:lsp_settings_servers_dir

    let g:lsp_settings = {
    \  'clangd': {'cmd': ['clangd-6.0']},
    \  'efm-langserver': {'disabled': v:false},
    \   'pyls-all': {
    \     'workspace_config': {
    \       'pyls': {
    \         'configurationSources': ['flake8']
    \       }
    \     }
    \   },
    \}

    " use of specific servers:
    "let g:lsp_settings_filetype_perl = 'slp'
    "let g:lsp_settings_filetype_html = ['html-languageserver', 'angular-language-server']
    let g:lsp_settings_filetype_python = ['pyls-ms', 'pyls']
    let g:lsp_settings_filetype_lua = ['sumneko-lua-language-server']
    let g:lsp_settings_filetype_typescript = ['typescript-language-server', 'eslint-language-server']
endif
