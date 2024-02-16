" Plugin manager {
    " Required:
    filetype off

    "" set the runtime path to include Vundle and initialize
    set rtp+=$USERPROFILE/vimfiles/bundle/Vundle.vim
    call vundle#begin('$USERPROFILE/vimfiles/bundle/')

    Plugin 'gmarik/Vundle.vim'
    Plugin 'bling/vim-airline'
	"Plugin 'vim-airline/vim-airline-themes'
    Plugin 'Valloric/YouCompleteMe'
    Plugin 'scrooloose/syntastic'
    "Plugin 'google/vim-colorscheme-primary'
    Plugin 'NLKNguyen/papercolor-theme'
    Plugin 'junegunn/vim-easy-align'
    Plugin 'scrooloose/nerdcommenter'
    Plugin 'godlygeek/tabular'
    Plugin 'vim-scripts/indentpython.vim'
    Plugin 'nvie/vim-flake8'
   
    " All of your Plugins must be added before the following line
    call vundle#end()            " required

" } Plugin manager

" Extra plugins {
    set runtimepath^=~/.vim/bundle/ctrlp.vim
" } Extra plugins

" Use before config if available {
    if filereadable(expand("~/.vimrc.before"))
        source ~/.vimrc.before
    endif
" }
