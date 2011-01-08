[ -n "$PS1" ] || return 0

[ -f ~/lib/xix ] && { . ~/lib/xix; sourcedir "$XIX_ETC/bash/init"; }
