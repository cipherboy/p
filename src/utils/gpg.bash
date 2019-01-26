__p_gpg_is_id() {
    local id="$1"
    local lines="$(gpg2 --with-colons --list-keys "$id" | grep '^pub:' | wc -l)"

    if (( lines == 1 )); then
        return 0
    else
        return 1
    fi
}

__p_gpg_get_fingerprint() {
    local id="$1"

    gpg2 --with-colons --list-keys --keyid-format LONG "$id" | grep -C 1 '^pub:' | grep '^fpr:' | awk -F ':' '{print $(NF-1)}'
}

__p_gpg_export_key() {
    local id="$1"
    local file="$2"

    gpg2 --armor --output "$file" --export "$id"
}
