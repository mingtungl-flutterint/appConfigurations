" tabular.vim
"

if g:tabular_enabled
    let g:tabular_loaded = 1

    "" Tabular mappings
    if exists(":Tabularize")
        nnoremap <leader>Tab :Tabularize /
        vnoremap <leader>Tab :Tabularize /
        nnoremap <leader>Tab= :Tabularize /=<CR>
        vnoremap <leader>Tab= :Tabularize /=<CR>
        "nnoremap <leader>Tab| :Tabularize / |<CR>
        ""vnoremap <leader>Tab| :Tabularize /|\zs/l0r1<CR>
    endif

    function! s:align()
      let p = '^\s*|\s.*\s|\s*$'
      if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
        let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
        let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
        Tabularize/|/l1
        normal! 0
        call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
      endif
    endfunction
endif
