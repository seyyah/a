# check if console is interactive
isinteractive() {
	tty -s 2>/dev/null
}

# ask user for an input with default value
ask() {
	local prompt="$1"

	unset REPLY
	if [ $# -gt 1 ]; then
		local default="$2"
		read -p "$prompt [$default]? " REPLY
		[ -n "$REPLY" ] || REPLY="$default"
	else
		read -p "$prompt? " REPLY
	fi

	# answer is in REPLY
}

# ask for yes (evet)/no (hayır) with a default answer
yesno() {
	local default prompt answer

	default=${2:-'e'}

	case "$default" in
	[eEyY]*) prompt="[E/h]" ;;
	[hHnN]*) prompt="[e/H]" ;;
	esac

	while :; do
		echo -n "$1 $prompt "
		read answer

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
			echo "Lütfen '[e]vet' veya '[h]ayır' girin"
			;;
		esac
	done
}
