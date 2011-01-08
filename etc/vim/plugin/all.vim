" All modes.
augroup alledit
	" Always enter to the directory where the edited file resides.
	autocmd BufEnter * lcd %:p:h

	" When editing a file, always jump to the last known cursor position.
	" Don't do it when the position is invalid or when inside an event handler
	" (happens when dropping a file on gvim).
	autocmd BufReadPost *
		\ if line("'\"") > 0 && line("'\"") <= line("$") |
		\	execute "normal g`\"" |
		\ endif

	" Default style
	" autocmd BufRead,BufNewFile * if &ft == '' | set tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab | endif
	set tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
	" Always highlight the following words.
	autocmd BufRead,BufNewFile * syntax keyword Todo TODO XXX FIXME

	" Format lists.
	function! FormatList(...)
		let mode = (a:0 > 0) ? a:1 : &ft

		execute 'autocmd FileType ' . mode . ' setlocal ' .
				\ 'formatoptions+=tcqn ' .
				\ 'comments-=mb:* comments-=fb:- comments+=fb:-,fb:+,fb:*,fb::'
		execute 'autocmd FileType ' . mode . ' setl ' .
			\ 'formatlistpat=^\\s*\\(\\(\\d\\+\\\|[a-zA-Z]\\)[\\].)]\\s*\\\\|\\[\\w\\+\\][:]*\\s\\+\\)'
	endfunction
	for ft in ['text', 'mail', 'git', 'svn', 'markdown', 'rst', 'debchangelog']
		call FormatList(ft)
	endfor

	"When .vimrc is edited, reload it
	autocmd! BufWritePost .vimrc source ~/.vimrc

	if &term != 'builtin-gui'
		let &titleold = substitute(getcwd(), '^' . $HOME, '~', '')
		set title
	endif
augroup END

if $TERM == 'screen' || $TERM == 'screen-256color'
	execute "set title titlestring=%f | set title t_ts=\<ESC>k t_fs=\<ESC>\\"
endif
