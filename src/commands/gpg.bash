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
    local gpg_name="$1"
    local gpg_email="$2"
    local gpg_password="$3"

    ___p_gpg_generate_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    if __p_gpg_is_id "$gpg_name" "$gpg_email"; then
        __e "Error: resulting GPG key will not be uniquely determined by: $gpg_name and $gpg_email"
        return 1
    fi

    # Create a temporary directory for the new key.
    local tmpdir="$(__p_mk_secure_tmp)"
    pushd "$tmpdir" >/dev/null
        if [ -n "$gpg_password" ]; then
            __p_gpg_batch_generate "$tmpdir/key.batch" "$gpg_name" "$gpg_email" "$gpg_password"
        else
            __p_gpg_batch_generate "$tmpdir/key.batch" "$gpg_name" "$gpg_email"
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
    local gpg_path="$1"

    ___p_gpg_import_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    __gpg --import "$gpg_path"
}

function ___p_gpg_export() {
    local gpg_id="$1"
    local gpg_path="$2"

    ___p_gpg_export_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    __gpg --export --armor "$gpg_id" > "$gpg_path"
}

function ___p_gpg_list() {
    __gpg --list-keys --keyid-format LONG "$@"
}

function ___p_gpg_password() {
    local gpg_id="$1"

    ___p_gpg_password_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    __gpg --edit-key "$gpg_id" password
}

function ___p_gpg_trust() {
    local gpg_id="$1"

    ___p_gpg_trust_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    echo -e "4\nsave\n" | __gpg --command-fd 0 --expert --edit-key "$gpg_id" trust
    __gpg --edit-key "$gpg_id" sign
}
