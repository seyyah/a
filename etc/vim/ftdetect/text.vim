" Note that, there is no such text type in VIM distribution.
" Files with all upper case names are accepted as text files.
autocmd BufNewFile,BufRead *.txt,[A-Z]\+ if &ft != '' | setl filetype=text | endif
" Files edited from are also accepted as text files.
autocmd BufNewFile,BufRead *.w3m/w3mtmp* set filetype=text
