aptinstall() {
	apt-get install -o APT::Get::HideAutoRemove=1 -q -y --no-install-recommends "$@"
}

geminstall() {
	gem install --quiet "$@"
}

wajig() {
	local url; for url; do wajig -n -q -y install "$url"; done
}
