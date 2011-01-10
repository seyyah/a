# check if console is interactive
isinteractive() {
	tty -s 2>/dev/null
}

# öntanımlı değeri bekleterek kullanıcıdan girdi iste
ask() {
	local prompt="$1"

	unset REPLY
	if [ $# -gt 1 ]; then
		local default="$2"
		printf "${HILITE}${prompt} ${NORMAL}[${BRACKET}$default${NORMAL}]? "
		read REPLY </dev/tty
		[ -n "$REPLY" ] || REPLY="$default"
	else
		printf "${HILITE}${prompt}${NORMAL}? "
		read REPLY </dev/tty
	fi

	# answer is in REPLY
}

# öntanımlı cevabı bekleterek kullanıcıya evet/hayır sor
yesno() {
	local default prompt answer

	default=${2:-'e'}

	case "$default" in
	[eEyY]*) prompt="[${BRACKET}E/h${NORMAL}]" ;;
	[hHnN]*) prompt="[${BRACKET}e/H${NORMAL}]" ;;
	esac

	while :; do
		printf "${HILITE}$1 $prompt ${NORMAL}"
		read answer </dev/tty

		case "${answer:-$default}" in
		[eE] | [eE][vV] | [eE][vV][eE] | [eE][vV][eE][tT] | \
		[yY] | [yY][eE] | [yY][eE][sS])
			return 0
			;;
		[hH] | [hH][aA] | [hH][aA][yY] | [hH][aA][yY][ıI] | [hH][aA][yY][ıI][rR] | \
		[nN] | [nN][oO])
			return 1
			;;
		*)
			printf "${BAD}Lütfen '[e]vet' veya '[h]ayır' girin${NORMAL}\n"
			;;
		esac
	done
}
