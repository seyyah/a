github_https() {
	curl -s -F "login=${XIX_GITHUB_USER}" -F "token=${XIX_GITHUB_TOKEN}" "https://github.com/api/v2/yaml/${*}"
}

github_http() {
	curl -s "http://github.com/api/v2/yaml/${*}"
}

yamlfield() {
	ruby -ryaml -e 'h = YAML.load(STDIN); puts h[h.keys.first]['"$field"']'
}

iswc() {
	case "$(LC_ALL=C GIT_DIR="$1/.git" /usr/bin/git rev-parse --is-inside-work-tree 2>/dev/null ||:)" in
	true)  return 0 ;;
	false) return 1 ;;
	*)     return 2 ;;
	esac
}

githubuserexist() {
	local user="$1"
	github_https "user/show/$user" | egrep -q '^\s+:'
}
githubrepoexist() {
	local repo="$1" user="${2:-$XIX_GITHUB_USER}"
	github_https "repos/show/$user/$repo" | egrep -q '^\s+:'
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
