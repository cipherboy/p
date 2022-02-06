__p_gpg_is_id() {
    local lines="$(__gpg --with-colons --list-keys "$@" 2>/dev/null | grep -c '^pub:')"

    if (( lines == 1 )); then
        return 0
    else
        return 1
    fi
}

__p_gpg_get_fingerprint() {
    if __p_gpg_is_id "$@"; then
        __gpg --with-colons --list-keys --keyid-format LONG "$@" | grep -C 1 '^pub:' | grep '^fpr:' | awk -F ':' '{print $(NF-1)}'
    else
        __e "Identifier is not unique:" "$@"
        return 1
    fi
}

__p_gpg_export_key() {
    local id="$1"
    local file="$2"

    __gpg --armor --output "$file" --export "$id"
}

__p_gpg_batch_generate() {
    local filename="$1"
    local name="$2"
    local email="$3"
    local password="$4"
    local no_password="$5"

    {
        echo "Key-Type: RSA"
        echo "Key-Length: 4096"
        echo "Key-Usage: sign,auth"
        if (( $# == 4 )); then
            echo "Passphrase: $password"
        fi
        echo "Subkey-Type: RSA"
        echo "Subkey-Length: 4096"
        echo "Subkey-Usage: encrypt,sign"
        echo "Name-Real: $name"
        echo "Name-Email: $email"
        echo "Expire-Date: 35y"
        if (( $# == 5)) && [ "$no_password" == "true" ]; then
            echo "%no-protection"
        fi
        echo "%commit"
    } > "$filename"

    __gpg --batch --generate-key "$filename"
}
