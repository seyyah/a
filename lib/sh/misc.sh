# yaml alanı
yamlfield() {
	ruby -ryaml -e 'h = YAML.load(STDIN); puts h[h.keys.first]['"$field"']'
}

