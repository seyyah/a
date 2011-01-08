# Essential shell helpers for XIX
# Copyright ©, 2010 roktas
# Licensed under WTFPL http://sam.zoy.org/wtfpl/

# iletiyi stderr'de görüntüle
message() {
	echo "$*" | fold -s -w ${COLUMNS:-80} >&2
}

# iletiyi satır sonu olmadan stderr'de görüntüle
messagen() {
	echo -n "$*" | fold -s -w ${COLUMNS:-80} >&2
}

# iletilerde kaynak isteniyorsa ekle
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
	message_ "$*"
}

# hata iletisi
die() {
	message_ "$*"
	exit 19
}

# ayrıntılı ileti
if [ -n "$VERBOSE" ]; then
	verbose() { message_ "$@"; }
else
	verbose() { :; }
fi

# öngörülemeyen yazılım hatası
bug() {
	message_ "$@"
	cry "Bu bir yazılım hatası, lütfen raporlayın."
	exit 70
}

missingdeb() {
	pathfind dpkg-query || bug "dpkg yok; bu bir Debian türevi mi?"

	local pkg missing=
	for pkg; do
		if ! dpkg-query -W "$pkg" >/dev/null 2>&1; then
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
		local prompt=${*:-'Yönetici hakları gerekiyor.  Lütfen "%u" için parola girin: '}
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

# geçici dizin oluştur
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

# işlevleri alt kabuğa ihraç et (bash için)
if [ -n "$BASH" ]; then
	export -f message messagen die cry verbose bug \
			  missingdeb missinggem ensuredeb ensuregem \
			  sudostart isprivileged usetempdir has
fi
