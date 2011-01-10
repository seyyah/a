# github api erişimi
github_api_access() {
	local args user token url https quiet format command reply

	args=$(getopt "squ:t:f:" $*) || bug "getopt hatası: $*"

	set -- $args
	while [ $# -ge 0 ]; do
		case "$1" in
		-s) https=yes;   shift ;;
		-q)	quiet=yes;   shift ;;
		-u) user="$2";   shift; shift ;;
		-t) token="$2";	 shift; shift ;;
		-f) format="$2"; shift; shift ;;
		--) shift; break ;;
		esac
	done

	[ $# -eq 1 ] || bug "eksik veya fazla argüman"

	: ${user:="$XIX_GITHUB_USER"}
	: ${token:="$XIX_GITHUB_TOKEN"}
	: ${format:='yaml'}

	url=$(printf "$1" "$user")

	if [ -n "$https" ]; then
		[ -n "$user"  ] || bug "GitHub hesabı verilmeli"
		[ -n "$token" ] || bug "GitHub token verilmeli"
		command="curl -s -F 'login=${user}' -F 'token=${token}' https://github.com/api/v2/${format}/${url}"
	else
		command="curl -s http://github.com/api/v2/${format}/${url}"
	fi

	reply=$($command 2>/dev/null)     || return
	echo "$reply" | egrep -q '^error' && return 1
	[ -z "$quiet" ]                   || return 0

	echo "$reply"
}

# github api için http ve https erişimleri
github_http()  { github_api_access    "$@"; }
github_https() { github_api_access -s "$@"; }

# github ssh ile erişilebilir durumda mı?
is_github_sshable() {
	# SSH kontrolünü sadece bir kere yapmak için sonucu sakla
	if [ -z "${IS_SSHABLE+X}" ]; then
		# SSH agent aktif değilse basitçe gerek şartları kontrol edeceğiz.
		if [ -z "$(ssh-add -l 2>/dev/null ||:)" ]; then
			# ~/.ssh dizini yok veya boşsa SSH kullanılamaz.
			if ! [ -d ~/.ssh ] || [ -r ~/.ssh/id_rsa ] || [ -r ~/.ssh/id_dsa ]; then
				IS_SSHABLE=no
			fi
		fi
		if [ -z "${IS_SSHABLE+X}" ]; then
			# Aksi halde daha yorucu ve çirkin bir kontrol gerekiyor.
			cry "SSH erişimi kontrol ediliyor (SSH parolası istenebilir)..."
			if ssh -T -o StrictHostKeyChecking=no git@github.com 2>&1 |
				egrep -q 'successfully authenticated'; then
				IS_SSHABLE=yes
			else
				IS_SSHABLE=no
			fi
		fi
	fi

	case "$IS_SSHABLE" in yes) return 0 ;; no) return 1 ;; esac
}

# verilen dizin bir git çalışma kopyası mı?
iswc() {
	case "$(
		LC_ALL=C GIT_DIR="$1/.git" /usr/bin/git rev-parse --is-inside-work-tree 2>/dev/null ||:
	)" in
	true)  return 0 ;;
	false) return 1 ;;
	*)     return 2 ;;
	esac
}

isgithubtoken() {
	local token="$1"
	[ ${#token} -eq 32 ] || return 1
	echo "$token" | egrep -q -v '[0-9a-fA-F]' && return 1
	return 0
}

if [ -z "${XIX_GITHUB_USER+X}" ]; then
	XIX_GITHUB_USER="$(git  config --global --get github.user  2>/dev/null)" ||:
	XIX_GITHUB_TOKEN="$(git config --global --get github.token 2>/dev/null)" ||:
	if [ -z "$XIX_GITHUB_TOKEN" ] && [ -r ~/.private/githubtoken ]; then
		XIX_GITHUB_TOKEN="$(cat ~/.private/githubtoken)" ||:
	fi
fi

if [ -z "${XIX_GIT_FULLNAME+X}" ]; then
	XIX_GIT_FULLNAME="$(git config --global --get user.name 2>/dev/null)" ||:
	XIX_GIT_EMAIL="$(git config --global --get user.email 2>/dev/null)" ||:
fi
