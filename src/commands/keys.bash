function ___p_keys() {
    __v "Value of _pc_keys: $_pc_keys"
    if [ "$_pc_keys" == "false" ]; then
        return 0
    fi

    local command="$1"
    shift

    if [ "x$command" == "xinit" ]; then
        ___p_keys_init "$@"
    elif [ "x$command" == "xlist" ]; then
        ___p_keys_list "$@"
    elif [ "x$command" == "ximport" ]; then
        ___p_keys_import "$@"
    elif [ "x$command" == "xexport" ]; then
        ___p_keys_export "$@"
    elif [ "x$command" == "xregen" ]; then
        ___p_keys_regen "$@"
    elif [ "x$command" == "xdelete" ]; then
        ___p_keys_delete "$@"
    elif [ "x$command" == "xrename" ]; then
        ___p_keys_rename "$@"
    elif [ "x$command" == "xgroups" ] || [ "x$command" == "xgroup" ] ||
            [ "x$command" == "xg" ]; then
        local subcommand="$1"
        shift

        if [ "x$subcommand" == "xcreate" ]; then
            ___p_keys_group_create "$@"
        elif [ "x$subcommand" == "xadd" ]; then
            ___p_keys_group_add "$@"
        elif [ "x$subcommand" == "xlist" ]; then
            ___p_keys_group_list "$@"
        elif [ "x$subcommand" == "xremove" ]; then
            ___p_keys_group_remove "$@"
        elif [ "x$subcommand" == "xdelete" ]; then
            ___p_keys_group_delete "$@"
        fi
    elif [ "x$command" == "xdirs" ] || [ "x$command" == "xdir" ] ||
            [ "x$command" == "xd" ]; then
        local subcommand="$1"
        shift

        if [ "x$subcommand" == "xcreate" ]; then
            ___p_keys_dir_create "$@"
        elif [ "x$subcommand" == "xadd" ]; then
            ___p_keys_dir_add "$@"
        elif [ "x$subcommand" == "xlist" ]; then
            ___p_keys_dir_list "$@"
        elif [ "x$subcommand" == "xregen" ]; then
            ___p_keys_dir_regen "$@"
        elif [ "x$subcommand" == "xremove" ]; then
            ___p_keys_dir_remove "$@"
        elif [ "x$subcommand" == "xdelete" ]; then
            ___p_keys_dir_delete "$@"
        fi
    else
        echo "Usage: p keys <cmd> [arguments]"
        echo "Manages encryption keys for password store."
        echo ""
        echo "Available commands:"
        echo " Key management:"
        echo "  - init <id>: initialize key management"
        echo "  - import <nickname> <id>: import a key from gpg's database"
        echo "  - export <nickname>: export a key into gpg's database and sign it"
        echo "  - list: list all keys tracked by p"
        echo "  - regen: recreate all .gpg-id files and re-encrypt accordingly"
        echo "  - delete <nickname>: delete a key and all its uses"
        echo "  - rename <old> <new>: rename a key"
        echo ""
        echo " Group management:"
        echo "  - group create @<group name> <nickname> [...]: create a new group"
        echo "  - group add @<group name> <nickname> [...]: add keys to group"
        echo "  - group remove @<group name> <nickname> [...]: remove keys from group"
        echo "  - group delete @<group name> <nickname> [...]: delete group"
        echo "  - group list: list all groups and their members"
        echo ""
        echo " Directory management:"
        echo "  - dir create /<path> <nickname> [...]: keys to encrypt path with"
        echo "  - dir add /<path> <nickname> [...]: add keys to list"
        echo "  - dir regen /<path>: regenerate .gpg-id and re-encrypt directory"
        echo "  - dir remove /<path> <nickname> [...]: remove keys from list"
        echo "  - dir delete /<path> <nickname> [...]: delete directory"
        echo "  - dir list: list all directories and their members"
        echo ""
        echo "Notes:"
        echo "  - A group may include other groups in the included key list."
        echo "  - All groups must begin with an @ symbol."
        echo "  - A directory may be assigned keys by nickname or groups."
        echo "  - After removing a group, directory, or key, a manual regen is required."
    fi
}

function ___p_keys_init() {
    local id="$1"
    local fingerprint="$(__p_gpg_get_fingerprint "$id")"
    local key_base="/.p/keys"
    local keys_absolute="$_p_pass_dir/$key_base"

    mkdir -p "$keys_absolute"

    __p_gpg_export_key "$fingerprint" - |
        _pc_encrypt="true" ___p_encrypt - "$key_base/$fingerprint.pem"


    # Generate initial key configuration
    echo "{}" |
        jq ".keys={\"default\": \"$fingerprint\"}" |
        jq '.groups={}' |
        jq ".dirs={\"/\": [\"default\"]}" |
        _pc_encrypt="true" ___p_encrypt - "$key_base/config.json"
}

function ___p_keys_list() {
    local key_base="/.p/keys"
    local config="$(_pc_decrypt="true" ___p_decrypt "$key_base/config.json" -)"

    for nickname in $(jq -r '.keys | keys[]' <<< "$config"); do
        local fingerprint="$(jq -r ".keys[\"$nickname\"]" <<< "$config")"
        echo "nickname: $nickname"
        echo "fingerprint: $fingerprint"
        echo "key info:"

        # Display information about the key
        _pc_decrypt="true" ___p_decrypt "$key_base/$fingerprint.pem" - |
            gpg2 --dry-run --keyid-format long --import-options show-only \
                --import 2>/dev/null |
            sed 's/^/    /g'
    done
}

function ___p_keys_import() {
    local nickname="$1"
    local id="$2"
    local fingerprint="$(__p_gpg_get_fingerprint "$id")"
    local key_base="/.p/keys"

    if [ "x$fingerprint" == "x" ]; then
        echo "To see a list of available keys: \`gpg2 --list-keys\`"
        return 1
    fi

    __p_gpg_export_key "$fingerprint" - |
        _pc_encrypt="true" ___p_encrypt - "$key_base/$fingerprint.pem"

    local config="$(_pc_decrypt="true" ___p_decrypt "$key_base/config.json" -)"

    cat - <<< "$config" |
        jq ".keys[\"$nickname\"]=\"$fingerprint\"" |
        _pc_encrypt="true" ___p_encrypt - "$key_base/config.json"
}

function ___p_keys_export() {
    local nickname="$1"
    local key_base="/.p/keys"
    local config="$(_pc_decrypt="true" ___p_decrypt "$key_base/config.json" -)"
    local fingerprint="$(jq -r ".keys[\"$nickname\"]" <<< "$config")"

    if [ "x$fingerprint" == "xnull" ]; then
        __e "Unknown key for nickname: $nickname"
        return 1
    fi

    _pc_open="true" ___p_open --read-only "$key_base/$fingerprint.pem" -- __gpg --import
}

function ___p_keys_delete() {
    local nickname="$1"
    local key_base="/.p/keys"
    local config="$(_pc_decrypt="true" ___p_decrypt "$key_base/config.json" -)"
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

    _pc_rm="true" ___p_rm -rf "$key_base/$fingerprint.pem"

    _pc_encrypt="true" ___p_encrypt - "$key_base/config.json" <<< "$updated"
}

function ___p_keys_rename() {
    local nickname="$1"
    local new_nickname="$2"
    local key_base="/.p/keys"
    local config="$(_pc_decrypt="true" ___p_decrypt "$key_base/config.json" -)"
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

    _pc_encrypt="true" ___p_encrypt - "$key_base/config.json" <<< "$updated"
}

function ___p_keys_group_create() {
    local key_base="/.p/keys"
    local name="$1"
    shift

    if [ "${name:0:1}" != "@" ]; then
        __e "Group name must begin with \`@\`: $name"
        return 1
    fi

    local config="$(_pc_decrypt="true" ___p_decrypt "$key_base/config.json" -)"

    local updated="$(jq ".groups[\"$name\"]=[]" <<< "$config")"

    for arg in "$@"; do
        updated="$(jq ".groups[\"$name\"]+=[\"$arg\"]" <<< "$updated")"
    done

    _pc_encrypt="true" ___p_encrypt - "$key_base/config.json" <<< "$updated"
}

function ___p_keys_group_add() {
    local key_base="/.p/keys"
    local name="$1"
    shift

    if [ "${name:0:1}" != "@" ]; then
        __e "Group name must begin with \`@\`: $name"
        return 1
    fi

    local updated="$(_pc_decrypt="true" ___p_decrypt "$key_base/config.json" -)"

    for arg in "$@"; do
        updated="$(jq ".groups[\"$name\"]+=[\"$arg\"]" <<< "$updated")"
    done

    _pc_encrypt="true" ___p_encrypt - "$key_base/config.json" <<< "$updated"
}

function ___p_keys_group_list() {
    local key_base="/.p/keys"
    local config="$(_pc_decrypt="true" ___p_decrypt "$key_base/config.json" -)"

    for name in $(jq -r ".groups | keys[]" <<< "$config"); do
        echo "group: $name"
        for groupindex in $(jq -r ".groups[\"$name\"] | keys[]" <<< "$config"); do
            local value="$(jq -r ".groups[\"$name\"][$groupindex]" <<< "$config")"
            echo "  member: $value"
            names+=("$value")
        done
    done
}

function ___p_keys_group_remove() {
    local key_base="/.p/keys"
    local name="$1"
    shift

    if [ "${name:0:1}" != "@" ]; then
        __e "Group name must begin with \`@\`: $name"
        return 1
    fi

    local updated="$(_pc_decrypt="true" ___p_decrypt "$key_base/config.json" -)"

    for arg in "$@"; do
        updated="$(jq ".groups[\"$name\"]-=[\"$arg\"]" <<< "$updated")"
    done

    _pc_encrypt="true" ___p_encrypt - "$key_base/config.json" <<< "$updated"
}

function ___p_keys_group_delete() {
    local key_base="/.p/keys"
    local name="$1"

    if [ "${name:0:1}" != "@" ]; then
        __e "Group name must begin with \`@\`: $name"
        return 1
    fi

    local config="$(_pc_decrypt="true" ___p_decrypt "$key_base/config.json" -)"
    local updated="$(jq "del(.groups[\"$name\"])" <<< "$config")"

    _pc_encrypt="true" ___p_encrypt - "$key_base/config.json" <<< "$updated"
}

function ___p_keys_dir_create() {
    local key_base="/.p/keys"
    local dir="$1"
    shift

    if [ "${dir:0:1}" != "/" ]; then
        __e "Directory name must begin with \`/\`: $dir"
        return 1
    fi

    local config="$(_pc_decrypt="true" ___p_decrypt "$key_base/config.json" -)"

    local updated="$(jq ".dirs[\"$dir\"]=[]" <<< "$config")"

    for arg in "$@"; do
        updated="$(jq ".dirs[\"$dir\"]+=[\"$arg\"]" <<< "$updated")"
    done

    _pc_encrypt="true" ___p_encrypt - "$key_base/config.json" <<< "$updated"
}

function ___p_keys_dir_add() {
    local key_base="/.p/keys"
    local dir="$1"
    shift

    if [ "${dir:0:1}" != "/" ]; then
        __e "Directory name must begin with \`/\`: $dir"
        return 1
    fi

    local updated="$(_pc_decrypt="true" ___p_decrypt "$key_base/config.json" -)"

    for arg in "$@"; do
        updated="$(jq ".dirs[\"$dir\"]+=[\"$arg\"]" <<< "$updated")"
    done

    _pc_encrypt="true" ___p_encrypt - "$key_base/config.json" <<< "$updated"
}

function ___p_keys_dir_list() {
    local key_base="/.p/keys"
    local config="$(_pc_decrypt="true" ___p_decrypt "$key_base/config.json" -)"

    for dir in $(jq -r ".dirs | keys[]" <<< "$config"); do
        echo "dir: $dir"
        for dirindex in $(jq -r ".dirs[\"$dir\"] | keys[]" <<< "$config"); do
            local value="$(jq -r ".dirs[\"$dir\"][$dirindex]" <<< "$config")"
            echo "  member: $value"
            names+=("$value")
        done
    done
}

function ___p_keys_dir_regen() {
    local key_base="/.p/keys"
    local dir="$1"
    shift

    if [ "${dir:0:1}" != "/" ]; then
        __e "Directory name must begin with \`/\`: $dir"
        return 1
    fi

    local config="$(_pc_decrypt="true" ___p_decrypt "$key_base/config.json" -)"

    if [ ! -d "$_p_pass_dir/$dir" ]; then
        __e "Directory does not exist on disk: $dir"
        return 1
    fi

    if [ "x$(jq -r ".dirs[\"$dir\"]" <<< "$config")" == "xnull" ]; then
        __e "Directory is not tracked by keys: $dir"
        return 1
    fi

    echo "Regenerating keys for \`$dir\`..."
    local path="$_p_pass_dir/$dir"
    local gpgid="$path/.gpg-id"

    local fingerprints=()
    local names=()

    rm "$gpgid" && touch "$gpgid"
    for index in $(jq -r ".dirs[\"$dir\"] | keys[]" <<< "$config"); do
        local name="$(jq -r ".dirs[\"$dir\"][$index]" <<< "$config")"
        names+=("$name")
    done

    while (( ${#names} > 0 )); do
        local name="${names[0]}"
        unset names[0]
        names=("${names[@]}")

        if [ "x${name:0:1}" == "x@" ]; then
            echo " group: $name:"
            for groupindex in $(jq -r ".groups[\"$name\"] | keys[]" <<< "$config"); do
                local value="$(jq -r ".groups[\"$name\"][$groupindex]" <<< "$config")"
                echo "   member: $value"
                names+=("$value")
            done
        else
            local fingerprint="$(jq -r ".keys[\"$name\"]" <<< "$config")"
            echo " key: $name=$fingerprint"
            echo "$fingerprint" >> "$gpgid"
        fi
    done

    local sorted="$(sort -u "$gpgid")"
    cat - <<< "$sorted" > "$gpgid"
    pass init --path="$dir" $(cat "$gpgid")
}

function ___p_keys_dir_remove() {
    local key_base="/.p/keys"
    local dir="$1"
    shift

    if [ "${dir:0:1}" != "/" ]; then
        __e "Directory name must begin with \`/\`: $dir"
        return 1
    fi

    local updated="$(_pc_decrypt="true" ___p_decrypt "$key_base/config.json" -)"

    for arg in "$@"; do
        updated="$(jq ".dirs[\"$dir\"]-=[\"$arg\"]" <<< "$updated")"
    done

    _pc_encrypt="true" ___p_encrypt - "$key_base/config.json" <<< "$updated"
}

function ___p_keys_dir_delete() {
    local key_base="/.p/keys"
    local dir="$1"

    if [ "${dir:0:1}" != "/" ]; then
        __e "Directory path must begin with \`/\`: $dir"
        return 1
    fi

    local config="$(_pc_decrypt="true" ___p_decrypt "$key_base/config.json" -)"
    local updated="$(jq "del(.dirs[\"$dir\"])" <<< "$config")"

    _pc_encrypt="true" ___p_encrypt - "$key_base/config.json" <<< "$updated"
}

function ___p_keys_regen() {
    local key_base="/.p/keys"
    local config="$(_pc_decrypt="true" ___p_decrypt "$key_base/config.json" -)"

    for dir in $(jq -r '.dirs | keys[]' <<< "$config"); do
        ___p_keys_dir_regen "$dir"
    done
}
