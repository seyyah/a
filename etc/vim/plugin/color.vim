set t_Co=256

" Tune up some colors as per HIG.
highlight PmenuSel cterm=bold,reverse ctermfg=cyan
highlight MatchParen ctermfg=red ctermbg=black

if has('gui_running')
	colorscheme github
	if has('unix')
		set guifont=Terminus\ Bold\ 16
	endif
else
	set background=dark
endif
