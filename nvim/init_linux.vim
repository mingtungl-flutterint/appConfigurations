" init_linux.vim
" Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=syntax spell:
" }

" Load plugin settings
if g:telescope_enabled
    luafile ~/.config/nvim/lua/config/telescope.lua
endif

if g:nvim_tree_enabled
    luafile ~/.config/nvim/lua/config/nvimtree.lua
endif

if g:galaxyline_enabled
    luafile ~/.config/nvim/lua/config/statusline/init.lua
endif
if g:compe_enabled
    luafile ~/.config/nvim/lua/config/compe.lua
endif

if g:gitsigns_enabled
    luafile ~/.config/nvim/lua/config/gitsigns.lua
endif

if g:webdevicons_enabled
    luafile ~/.config/nvim/lua/config/devicons.lua
endif

if g:whichkey_enabled
    luafile ~/.config/nvim/lua/config/whichkey.lua
endif
"" }
