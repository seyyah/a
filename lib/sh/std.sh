# Essential shell helpers for XIX
# Copyright ©, 2010 roktas
# Licensed under WTFPL http://sam.zoy.org/wtfpl/

# renkli ileti ortamını sıfırla
unsetcolors() {
	COLS=80

	GOOD=
	WARN=
	BAD=
	NORMAL=
	HILITE=
	BRACKET=
}

# renkli iletileri ve uçbirim genişliğini hazırla
setcolors() {
	COLS=${COLUMNS:-0}

	[ $COLS -eq 0 ] && COLS=$(set -- $(stty size </dev/tty 2>/dev/null); echo ${2:-0}) ||:
	[ $COLS -gt 0 ] || COLS=80

	if [ -n "${COLORMAP}" ] ; then
		eval ${COLORMAP}
	else
		GOOD='\033[32;01m'
		WARN='\033[33;01m'
		BAD='\033[31;01m'
		HILITE='\033[36;01m'
		BRACKET='\033[34;01m'
	fi
	NORMAL='\033[0m'
}

# renkli iletiler kullanılsın mı?
case "${NOCOLOR:-false}" in
yes|true)
	unsetcolors
	;;
no|false)
	setcolors
	;;
esac

# iletiyi stderr'de görüntüle
message() {
	printf "$*\n" | fold -s -w ${COLS:-80} >&2
}

# iletiyi satır sonu olmadan stderr'de görüntüle
messagen() {
	printf "$*" | fold -s -w ${COLS:-80} >&2
}

# iletilerde ileti kaynağı isteniyorsa ekle
if [ -n "$ERROR_MESSAGE_DOMAIN" ]; then
	message_ () {
		message "${ERROR_MESSAGE_DOMAIN}: $*"
	}
else
	message_ () {
		message "$*"
	}
fi

# uyarı iletisi
cry() {
	message_ "${WARN}${*}${NORMAL}"
}

# hata iletisi
die() {
	message_ "${BAD}${*}${NORMAL}"
	exit 19
}

# ayrıntılı ileti
if [ -n "$VERBOSE" ]; then
	verbose() { message_ "$@"; }
else
	verbose() { :; }
fi

# öngörülemeyen yazılım hatası iletisi
bug() {
	message_ "$@"
	cry "Bu bir yazılım hatası, lütfen raporlayın."
	exit 70
}

# renkli bir ileti
say() {
	message_ "${GOOD}${*}${NORMAL}"
}

# eksik deb paketleri
missingdeb() {
	pathfind dpkg-query || bug "dpkg yok; bu bir Debian türevi mi?"

	local pkg missing

	missing=
	for pkg; do
		if ! dpkg-query -s "$pkg" >/dev/null 2>&1; then
			missing="$missing $pkg"
		fi
	done

	echo $missing
}

missinggem() {
	pathfind gem || bug "ruby gem kurulu değil"

	local pkg missing=
	for pkg; do
		if ! gem query -i -n '^'"$pkg"'$' >/dev/null 2>&1; then
			missing="$missing $pkg"
		fi
	done

	echo $missing
}

ensuredeb() {
	local missing=$(missingdeb "$@")
	[ -z "$missing" ] || die "Devam etmeniz için şu paketlerin kurulması gerekiyor: " $missing
}

ensuregem() {
	local missing=$(missinggem "$@")
	[ -z "$missing" ] || die "Devam etmeniz için şu gem paketlerinin kurulması gerekiyor: " $missing
}

# sudo gerektiren işlemlerin öncesinde sudo parolası zaman aşımını tazele
sudostart() {
	if [ $(id -u) -ne 0 ]; then
		say "Yönetici hakkı gerekecek; sudo parolası sorulabilir."
		local prompt=${*:-'Lütfen "%u" için parola girin: '}
		if ! sudo -v -p "$prompt"; then
			die "Parolayı hatalı giriyorsunuz veya yönetici olma yetkiniz yok!"
		fi
	fi
}

# kullanıcı ayrıcalıklı mı?
isprivileged() {
	local g

	if [ $(id -u) -eq 0 ]; then
		return 0
	else
		for g in $(groups); do
			case "$g" in
			sudo|admin|wheel|staff)
				return 0 ;;
			esac
		done
	fi

	return 1
}

# güvenli geçici dizin oluştur
usetempdir() {
	local tempname="$1" keeptemp="$2"

	# As a security measure refuse to proceed if mktemp is not available.
	pathfind mktemp || die "'mktemp' bulunamadı; sonlanıyor."

	local tempdir="$(mktemp -d -t ${0##*/}.XXXXXXXX)"

	[ -d "$tempdir" ] || die "geçici bir dizin oluşturulamadı"

	eval $(echo "$tempname=\"$tempdir\"")

	if [ -z "$keeptemp" ]; then
		trap '
			exitcode=$?
			if [ -d "'$tempdir'" ]; then
				rm -rf "'$tempdir'"
			fi
			exit $exitcode
		' EXIT HUP INT QUIT TERM
	fi
}

# ilk argüman diğer argümanlarda geçiyor mu?
has() {
	local first="$1"; shift 2>/dev/null ||:
	case " $* " in *" $first "*) return 0 ;; esac
	return 1
}
