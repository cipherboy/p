function ___p_gpg() {
    local gpg_cmd=""

    ___p_gpg_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    ___p_gpg_dispatch_subparser
}

function ___p_gpg_generate() {
    local key_base="/.p/keys"
    local name="$1"
    local email="$2"

    if __p_gpg_is_id "$name" "$email"; then
        __e "Error: resulting GPG key will not be uniquely determined by: $name and $email"
        return 1
    fi

    # Create a temporary directory for the new key.
    local tmpdir="$(__p_mk_secure_tmp)"
    pushd "$tmpdir" >/dev/null
        if (( $# == 3 )); then
            local password="$3"
            __p_gpg_batch_generate "$tmpdir/key.batch" "$name" "$email" "$password"
        else
            __p_gpg_batch_generate "$tmpdir/key.batch" "$name" "$email"
        fi
        ret=$?
    popd >/dev/null

    if (( ret == 0 )); then
        __p_rm_secure_tmp "$tmpdir"
    else
        echo "Error during operation: refusing to remove $tmpdir"
    fi
}

function ___p_gpg_import() {
    local file="$1"

    __gpg --import "$file"
}

function ___p_gpg_export() {
    local id="$1"
    local file="$2"

    __gpg --export --armor "$id" > "$file"
}

function ___p_gpg_list() {
    __gpg --list-keys --keyid-format LONG "$@"
}

function ___p_gpg_password() {
    local id="$1"

    __gpg --edit-key "$id" password
}

function ___p_gpg_trust() {
    local id="$1"

    echo -e "4\nsave\n" | __gpg --command-fd 0 --expert --edit-key "$id" trust
    __gpg --edit-key "$id" sign
}
