" vimplug_manager.vim
"
"" Plug manager {
if WINDOWS()
    if has('nvim')
        if empty(glob('$LOCALAPPDATA/nvim-data/site/autoload/plug.vim'))
            silent powershell iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |
               \ ni "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim-data/site/autoload/plug.vim" -Force
            "autocmd VimEnter * PlugInstall
        endif
        let g:plugged_home = '$LOCALAPPDATA/nvim-data/site/plugged'
    else
        let g:plugged_home = '$USERPROFILE/vimfiles/bundle'
    endif
endif

if LINUX()
    " Autoinstall vim-plug
    if has('nvim')
        if empty(glob('$HOME/.local/share/nvim/site/autoload/plug.vim'))
            silent !sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        endif
        let g:plugged_home = '$HOME/.local/share/nvim/site/plugged'
    else
        if empty(glob('$HOME/.vim/autoload/plug.vim'))
            silent !sh -c 'curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        endif
        let g:plugged_home = '$HOME/.vim/plugged'
    endif
endif


call plug#begin(g:plugged_home)

if g:webdevicons_enabled
    "" Adds filetype glyphs (icons) to various vim plugins - load this plugin last
    Plug 'kyazdani42/nvim-web-devicons' " required - for file icons
    Plug 'ryanoasis/vim-devicons'
endif

"" color schemes
Plug 'NLKNguyen/papercolor-theme'
Plug 'joshdick/onedark.vim'

if g:galaxyline_enabled
    Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
endif

"" LSP
if g:lsp_enabled
" https://github.com/prabirshrestha/vim-lsp
    Plug 'prabirshrestha/vim-lsp'
" https://github.com/mattn/vim-lsp-settings
    Plug 'mattn/vim-lsp-settings'
endif

"" Auto-completion
if g:compe_enabled
    Plug 'hrsh7th/nvim-compe'
    Plug 'hrsh7th/vim-vsnip'
endif
if g:asyncomplete_enabled
    Plug 'prabirshrestha/async.vim'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'
endif

" Search
if g:telescope_enabled
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-media-files.nvim'
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
    "let g:fzf_enabled = 0
endif
if g:fzf_enabled
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
endif

" Explorer
if g:nvim_tree_enabled
    Plug 'kyazdani42/nvim-tree.lua'
endif

if g:python_enabled
    Plug 'vim-scripts/indentpython.vim'
    Plug 'nvie/vim-flake8'
endif

"" automatic closing of quotes, parenthesis, brackets, etc.
Plug 'jiangmiao/auto-pairs'
Plug 'frazrepo/vim-rainbow'

if g:gitsigns_enabled
    Plug 'nvim-lua/plenary.nvim'
    Plug 'lewis6991/gitsigns.nvim'
endif

"" additional syntax highlighting that I use for C++11/14/17
if g:cpp_enhanced_highlight_enabled
	Plug 'octol/vim-cpp-enhanced-highlight'
endif

if g:whichkey_enabled
    Plug 'liuchengxu/vim-which-key'
    Plug 'AckslD/nvim-whichkey-setup.lua'
endif

"" provides a start screen for Vim and Neovim
Plug 'mhinz/vim-startify'



"" All of your Plugs must be added before the following line
call plug#end()            " required
"" :PlugInstall [name ...] - to install plugins
"" :PlugUpdate [name ...] - to install or update
"" :PlugClean [!] - to remove unused directories
"" :PlugUpgrade - to upgrade plug itself

"" } Plug manager
