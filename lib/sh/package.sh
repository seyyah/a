# apt-get sarmalayıcı
apt() {
	local command
	command="$1"; shift 2>/dev/null ||:

	sudo apt-get $command --option APT::Get::HideAutoRemove=1 \
		--quiet --yes --force --no-install-recommends --ignore-missing "$@"
}

# aptitude sarmalayıcı
apti() {
	local command
	command="$1"; shift 2>/dev/null ||:
	sudo aptitude $command -f --quiet --assume-yes --without-recommends "$@"
}

# gem sarmalayıcı (öntanımlı)
gem() {
	local command
	command="$1"; shift 2>/dev/null ||:
	sudo gem $command --quiet "$@"
}

# gem sarmalayıcı (1.9 serisi ile)
gem191() {
	local command
	command="$1"; shift 2>/dev/null ||:
	sudo gem1.9.1 $command --quiet "$@"
}

# wajig sarmalayıcı
wajig() {
	local command
	command="$1"; shift 2>/dev/null ||:
	wajig -n -q -y $command "$@"
}
