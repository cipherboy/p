function ___p_keys() {
    local key_cmd=""

    ___p_keys_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    ___p_keys_dispatch_subparser
}

function ___p_key_init() {
    local key_id=""

    ___p_key_init_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    local fingerprint="$(__p_gpg_get_fingerprint "$key_id")"
    if [ "x$fingerprint" == "x" ]; then
        echo "To see a list of available keys: \`gpg2 --list-keys\`"
        return 1
    fi

    local keys_absolute="$_p_pass_dir/$_p_key_base"

    mkdir -p "$keys_absolute"

    __p_gpg_export_key "$fingerprint" - |
        ___p_encrypt - "$_p_key_base/$fingerprint.pem"

    # Generate initial key configuration
    echo "{}" |
        jq ".keys={\"default\": \"$fingerprint\"}" |
        jq '.groups={}' |
        jq ".dirs={\"/\": [\"default\"]}" |
        __p_keys_write_config
}

function ___p_key_list() {
    ___p_key_list_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    local config="$(__p_keys_read_config)"

    for nickname in $(jq -r '.keys | keys[]' <<< "$config"); do
        local fingerprint="$(jq -r ".keys[\"$nickname\"]" <<< "$config")"
        echo "nickname: $nickname"
        echo "fingerprint: $fingerprint"
        echo "key info:"

        # Display information about the key
        ___p_decrypt "$_p_key_base/$fingerprint.pem" - |
            __gpg --dry-run --keyid-format long --import-options show-only \
                --import 2>/dev/null |
            sed 's/^/    /g'
    done
}

function ___p_key_import() {
    local key_nickname=""
    local key_id=""

    ___p_key_import_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    local fingerprint="$(__p_gpg_get_fingerprint "$key_id")"
    if [ "x$fingerprint" == "x" ]; then
        echo "To see a list of available keys: \`gpg2 --list-keys\`"
        return 1
    fi

    __p_gpg_export_key "$fingerprint" - |
        ___p_encrypt - "$_p_key_base/$fingerprint.pem"

    local config="$(__p_keys_read_config)"

    cat - <<< "$config" |
        jq ".keys[\"$key_nickname\"]=\"$fingerprint\"" |
        __p_keys_write_config
}

function ___p_key_update() {
    local key_nickname="$1"

    ___p_key_update_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    local config="$(__p_keys_read_config)"
    local fingerprint="$(jq -r ".keys[\"$key_nickname\"]" <<< "$config")"
    if [ "x$fingerprint" == "xnull" ]; then
        __e "Unknown key for nickname: $key_nickname"
        return 1
    fi

    ___p_open --read-only "$_p_key_base/$fingerprint.pem" -- __gpg --import

    __p_gpg_export_key "$fingerprint" - |
        ___p_encrypt - "$_p_key_base/$fingerprint.pem"
}

function ___p_key_export() {
    local key_nickname="$1"

    ___p_key_list_export_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    local config="$(__p_keys_read_config)"
    local fingerprint="$(jq -r ".keys[\"$key_nickname\"]" <<< "$config")"
    if [ "x$fingerprint" == "xnull" ]; then
        __e "Unknown key for nickname: $key_nickname"
        return 1
    fi

    ___p_open --read-only "$_p_key_base/$fingerprint.pem" -- __gpg --import
}

function ___p_key_delete() {
    local key_nickname="$1"

    ___p_key_delete_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    local config="$(__p_keys_read_config)"
    local fingerprint="$(jq -r ".keys[\"$key_nickname\"]" <<< "$config")"
    if [ "x$fingerprint" == "xnull" ]; then
        __e "Unknown key for nickname: $key_nickname"
        return 1
    fi

    local updated="$(jq "del(.keys[\"$key_nickname\"])" <<< "$config")"

    for name in $(jq -r ".groups | keys[]" <<< "$config"); do
        updated="$(jq ".groups[\"$name\"]-=[\"$key_nickname\"]" <<< "$updated")"
    done

    for dir in $(jq -r ".dirs | keys[]" <<< "$config"); do
        updated="$(jq ".dirs[\"$dir\"]-=[\"$key_nickname\"]" <<< "$updated")"
    done

    ___p_rm -f "$_p_key_base/$fingerprint.pem"

    __p_keys_write_config <<< "$updated"
}

function ___p_key_rename() {
    local key_old="$1"
    local key_new="$2"

    ___p_key_rename_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    local config="$(__p_keys_read_config)"
    local fingerprint="$(jq -r ".keys[\"$key_old\"]" <<< "$config")"
    if [ "x$fingerprint" == "xnull" ]; then
        __e "Unknown key for nickname: $key_old"
        return 1
    fi

    local updated="$(jq "del(.keys[\"$key_old\"])" <<< "$config")"
    updated="$(jq ".keys[\"$key_new\"]=\"$fingerprint\"" <<< "$updated")"

    for name in $(jq -r ".groups | keys[]" <<< "$config"); do
        updated="$(jq "( .groups[\"$name\"] | select(\"$key_old\") ) |= \"$key_new\"" <<< "$updated")"
    done

    for dir in $(jq -r ".dirs | keys[]" <<< "$config"); do
        updated="$(jq "( .dirs[\"$dir\"] | select(\"$key_old\") ) |= \"$key_new\"" <<< "$updated")"
    done

    __p_keys_write_config <<< "$updated"
}

function ___p_key_regen() {
    ___p_key_regen_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    local config="$(__p_keys_read_config)"

    for dir in $(jq -r '.dirs | keys[]' <<< "$config"); do
        ___p_dir_regen "$dir"
    done
}
