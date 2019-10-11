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
    local id="$1"
    local fingerprint="$(__p_gpg_get_fingerprint "$id")"
    local key_base="/.p/keys"
    local keys_absolute="$_p_pass_dir/$key_base"

    mkdir -p "$keys_absolute"

    __p_gpg_export_key "$fingerprint" - |
        ___p_encrypt - "$key_base/$fingerprint.pem"


    # Generate initial key configuration
    echo "{}" |
        jq ".keys={\"default\": \"$fingerprint\"}" |
        jq '.groups={}' |
        jq ".dirs={\"/\": [\"default\"]}" |
        __p_keys_write_config
}

function ___p_key_list() {
    local key_base="/.p/keys"
    local config="$(__p_keys_read_config)"

    for nickname in $(jq -r '.keys | keys[]' <<< "$config"); do
        local fingerprint="$(jq -r ".keys[\"$nickname\"]" <<< "$config")"
        echo "nickname: $nickname"
        echo "fingerprint: $fingerprint"
        echo "key info:"

        # Display information about the key
        ___p_decrypt "$key_base/$fingerprint.pem" - |
            __gpg --dry-run --keyid-format long --import-options show-only \
                --import 2>/dev/null |
            sed 's/^/    /g'
    done
}

function ___p_key_import() {
    local nickname="$1"
    local id="$2"
    local fingerprint="$(__p_gpg_get_fingerprint "$id")"
    local key_base="/.p/keys"

    if [ "x$fingerprint" == "x" ]; then
        echo "To see a list of available keys: \`gpg2 --list-keys\`"
        return 1
    fi

    __p_gpg_export_key "$fingerprint" - |
        ___p_encrypt - "$key_base/$fingerprint.pem"

    local config="$(__p_keys_read_config)"

    cat - <<< "$config" |
        jq ".keys[\"$nickname\"]=\"$fingerprint\"" |
        __p_keys_write_config
}

function ___p_key_update() {
    local nickname="$1"
    local key_base="/.p/keys"
    local config="$(__p_keys_read_config)"
    local fingerprint="$(jq -r ".keys[\"$nickname\"]" <<< "$config")"

    ___p_open --read-only "$key_base/$fingerprint.pem" -- __gpg --import

    __p_gpg_export_key "$fingerprint" - |
        ___p_encrypt - "$key_base/$fingerprint.pem"
}

function ___p_key_export() {
    local nickname="$1"
    local key_base="/.p/keys"
    local config="$(__p_keys_read_config)"
    local fingerprint="$(jq -r ".keys[\"$nickname\"]" <<< "$config")"

    if [ "x$fingerprint" == "xnull" ]; then
        __e "Unknown key for nickname: $nickname"
        return 1
    fi

    ___p_open --read-only "$key_base/$fingerprint.pem" -- __gpg --import
}

function ___p_key_delete() {
    local nickname="$1"
    local key_base="/.p/keys"
    local config="$(__p_keys_read_config)"
    local fingerprint="$(jq -r ".keys[\"$nickname\"]" <<< "$config")"

    if [ "x$fingerprint" == "xnull" ]; then
        __e "Unknown key for nickname: $nickname"
        return 1
    fi

    local updated="$(jq "del(.keys[\"$nickname\"])" <<< "$config")"

    for name in $(jq -r ".groups | keys[]" <<< "$config"); do
        updated="$(jq ".groups[\"$name\"]-=[\"$nickname\"]" <<< "$updated")"
    done

    for dir in $(jq -r ".dirs | keys[]" <<< "$config"); do
        updated="$(jq ".dirs[\"$dir\"]-=[\"$nickname\"]" <<< "$updated")"
    done

    ___p_rm -rf "$key_base/$fingerprint.pem"

    __p_keys_write_config <<< "$updated"
}

function ___p_key_rename() {
    local nickname="$1"
    local new_nickname="$2"
    local key_base="/.p/keys"
    local config="$(__p_keys_read_config)"
    local fingerprint="$(jq -r ".keys[\"$nickname\"]" <<< "$config")"

    if [ "x$fingerprint" == "xnull" ]; then
        __e "Unknown key for nickname: $nickname"
        return 1
    fi

    local updated="$(jq "del(.keys[\"$nickname\"])" <<< "$config")"
    updated="$(jq ".keys[\"$new_nickname\"]=\"$fingerprint\"" <<< "$updated")"

    for name in $(jq -r ".groups | keys[]" <<< "$config"); do
        updated="$(jq "( .groups[\"$name\"] | select(\"$nickname\") ) |= \"$new_nickname\"" <<< "$updated")"
    done

    for dir in $(jq -r ".dirs | keys[]" <<< "$config"); do
        updated="$(jq "( .dirs[\"$dir\"] | select(\"$nickname\") ) |= \"$new_nickname\"" <<< "$updated")"
    done

    __p_keys_write_config <<< "$updated"
}

function ___p_key_regen() {
    local key_base="/.p/keys"
    local config="$(__p_keys_read_config)"

    for dir in $(jq -r '.dirs | keys[]' <<< "$config"); do
        ___p_dir_regen "$dir"
    done
}
