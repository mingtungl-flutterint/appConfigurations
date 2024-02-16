
" Plug manager {
    " Required:
    filetype off
    if WINDOWS()
        let g:plugged_home = '$USERPROFILE/vimfiles/bundle'
    else
        let g:plugged_home = '~/.vim/bundle'
    endif
    call plug#begin(g:plugged_home)

    " Autocomplete
    "Plug 'ncm2/ncm2'
    let g:ncm2_enabled = 0
    "Plug 'roxma/nvim-yarp'
    "Plug 'ncm2/ncm2-bufword'
    "Plug 'ncm2/ncm2-path'
    "Plug 'ncm2/ncm2-jedi'

    " linter
    "Plug 'w0rp/ale'

    " color schemes
    "Plug 'google/vim-colorscheme-primary'
    Plug 'NLKNguyen/papercolor-theme'
    Plug 'joshdick/onedark.vim'

    Plug 'bling/vim-airline'
    let g:airline_enabled = 1
    Plug 'vim-airline/vim-airline-themes'
    "Plug 'iCyMind/NeoSolarized'
    "Plug 'Valloric/YouCompleteMe'
    let g:ycm_enabled = 0
    Plug 'scrooloose/syntastic'
    let g:syntastic_enabled = 1
    Plug 'scrooloose/nerdtree'
    let g:nerdtree_enabled = 1
    Plug 'scrooloose/nerdcommenter'
    let g:nerdcommenter_enabled = 1
    "Plug 'junegunn/vim-easy-align'
    Plug 'godlygeek/tabular'
    let g:tabular_enabled = 0
    "Plug 'vim-scripts/indentpython.vim'
    "Plug 'nvie/vim-flake8'
    " automatic closing of quotes, parenthesis, brackets, etc.
    "Plug 'raimondi/delimitmate'
   " additional syntax highlighting that I use for C++11/14/17
    Plug 'octol/vim-cpp-enhanced-highlight'
    let g:cpp_enhanced_highlight_enabled = 1
    " Adds filetype glyphs (icons) to various vim plugins
    Plug 'ryanoasis/vim-devicons'
    " provides a start screen for Vim and Neovim
    Plug 'mhinz/vim-startify'

    let g:ctrlp_enabled = 0
    let g:omni_complete_enabled = 0
    let g:autoclosetag_enabled = 0

    " All of your Plugs must be added before the following line
    call plug#end()            " required
    " :PlugInstall [name ...] - to install plugins
    " :PlugUpdate [name ...] - to install or update
    " :PlugClean [!] - to remove unused directories
    " :PlugUpgrade - to upgrade plug itself

" } Plug manager

