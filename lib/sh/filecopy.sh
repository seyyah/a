copy_files_without_overwrite() {
	local srcdir="$1"
	local destdir="$2"
	local backupdir="$3"

	if [ ! -d "$backupdir" ]; then
		bug "yedekleme dizini '$backupdir' mevcut değil"
	fi
	if [ ! -d "$destdir" ]; then
		bug "hedef dizin '$destdir' mevcut değil"
	fi

	local f
	for f in $(ls -A "$srcdir"); do
		local target="$destdir/$f"
		if [ -e "$target" ]; then
			local skel="/etc/skel/$f"
			if [ ! -s "$target" ] || { [ -f "$skel" ] && cmp -s $skel $target; }; then
				rm -rf "$target"
				verbose "mevcut hedef dosya '$target' silindi"
			else
				mv "$target" "$backupdir/"
				verbose "mevcut hedef dosya '$target' '$backupdir' dizinine taşındı"
			fi
		fi
		cp -a "$srcdir/$f" "$target"
		verbose "hedef dosya '$target' kopyalandı"
	done
}
