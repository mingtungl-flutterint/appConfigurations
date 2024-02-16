" plugin_devicons.vim
"
"" Devicons { https://github.com/ryanoasis/vim-devicons/wiki/Extra-Configuration
if g:webdevicons_enabled
    let g:webdevicons_enable_nerdtree = 1
    let g:webdevicons_conceal_nerdtree_brackets = 1     "" whether or not to show the nerdtree brackets around flags
    let g:webdevicons_enable_airline_tabline = 1        "" adding to vim-airline's tabline
    let g:webdevicons_enable_airline_statusline = 1     "" adding to vim-airline's statusline
    let g:webdevicons_enable_startify = 1               "" adding to vim-startify screen
    let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1   "" Force extra padding in NERDTree so that the filetype icons line up vertically
    let g:WebDevIconsUnicodeDecorateFolderNodes = 1     "" enable folder/directory glyph flag (disabled by default with 0)
    let g:DevIconsEnableFoldersOpenClose = 1            "" enable open and close folder/directory glyph flags (disabled by default with 0)
    let g:DevIconsEnableFolderPatternMatching = 1       "" enable pattern matching glyphs on folder/directory (enabled by default with 1)
    let g:DevIconsEnableFolderExtensionPatternMatching = 0  "" enable file extension pattern matching glyphs on folder/directory (disabled by default with 0)
    " enable custom folder/directory glyph exact matching
    " (enabled by default when g:WebDevIconsUnicodeDecorateFolderNodes is set to 1)
    let WebDevIconsUnicodeDecorateFolderNodesExactMatches = 1

    " change the default folder/directory glyph/icon
    let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol = 'ƛ'

    " change the default open folder/directory glyph/icon (default is '')
    let g:DevIconsDefaultFolderOpenSymbol = 'ƛ'

    " change the default dictionary mappings for file extension matches

    let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {} " needed
    let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['js'] = 'ƛ'

    " change the default dictionary mappings for exact file node matches

    let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols = {} " needed
    let g:WebDevIconsUnicodeDecorateFileNodesExactSymbols['MyReallyCoolFile.okay'] = 'ƛ'

    " add or override individual additional filetypes

    let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {} " needed
    let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['myext'] = 'ƛ'

    " add or override pattern matches for filetypes
    " these take precedence over the file extensions

    let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols = {} " needed
    let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['.*jquery.*\.js$'] = 'ƛ'            
endif
