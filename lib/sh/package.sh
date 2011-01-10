# aptitude sarmalayıcı
apti() {
	local command
	command="$1"
	shift 2>/dev/null ||:
	sudo aptitude "$command" -f --quiet --assume-yes --without-recommends "$@"
}

# deb paketlerini etkileşimsiz şekilde apt-get ile kur
aptinstall() {
	sudo apt-get install --option APT::Get::HideAutoRemove=1 \
		--quiet --yes --force --no-install-recommends --ignore-missing "$@"
}

# gem kur (sistem öntanımlısıyla)
geminstall() {
	sudo gem install --quiet "$@"
}

# gem kur (1.9 serisi ile)
gem191install() {
	sudo gem1.9.1 install --quiet "$@"
}

# wajig için sarmalayıcı
wajig() {
	local url; for url; do wajig -n -q -y install "$url"; done
}
