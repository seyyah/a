" QuickFix mode
augroup quickfix
	" Use space key to walk around quickfix list.
	autocmd FileType qf nnoremap <buffer> <space> <cr>:set cursorline\|wincmd p<cr>
augroup END

" TeX mode
augroup texedit
	autocmd FileType tex setl sw=2 iskeyword+=: fo=tcq2n
augroup END

augroup podedit
	" when editing a .pod file, you can :make it; and then the command
	" :cope will open a nice little window with all pod errors and
	" warnings, correctly recognized, so you can jump on the corresponding
	" lines in the pod source file only by selecting them.
	" 	-- Trick from Rafael Garcia Suarez
	autocmd FileType pod
		\ setl makeprg=podchecker\ -warnings\ %\ 2>&1\\\|sed\ 's,at.line,:&,'
	autocmd FileType pod
		\ setl errorformat=%m:at\ line\ %l\ in\ file\ %f
augroup END

augroup vimedit
	autocmd FileType vim setl fo=tcq2n tw=0
augroup END

augroup sgmledit
	" Sgml documentation style for FreeBSD.
	autocmd FileType html,sgml,xml setl sw=2 sts=2 fo=tcq2wa
augroup END

augroup mailedit
	" Use <d--> to delete from the current line to signature.
	autocmd FileType mail onoremap -- /\n^-- \=$\\|\%$/-1<cr>
	autocmd FileType mail setl tw=72 et fo=tcrq2nw
augroup END
autocmd BufUnload mutt-* call s:check_attachments()
" autocmd VimEnter mutt-* :s/>\(\s\)\@!/> /ge

augroup markdownedit
	autocmd FileType markdown setl et nosta sts=4 sw=4
augroup END

augroup otledit
	autocmd FileType vo_base setl foldcolumn=0
	autocmd BufRead,BufNewFile *.vala set ft=vala
augroup END
