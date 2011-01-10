# etkileşimsiz şekilde sadece istenen deb paketlerini kur
aptinstall() {
	sudo apt-get install --option APT::Get::HideAutoRemove=1 \
		--quiet --yes --no-install-recommends --ignore-missing "$@"
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
