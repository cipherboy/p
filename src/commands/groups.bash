function ___p_groups() {
    local groups_cmd=""

    ___p_groups_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    ___p_groups_dispatch_subparser
}

function ___p_group_create() {
    local key_base="/.p/keys"
    local name="$1"
    shift

    if [ "${name:0:1}" != "@" ]; then
        __e "Group name must begin with \`@\`: $name"
        return 1
    fi

    local config="$(__p_keys_read_config)"

    local updated="$(jq ".groups[\"$name\"]=[]" <<< "$config")"

    for arg in "$@"; do
        updated="$(jq ".groups[\"$name\"]+=[\"$arg\"]" <<< "$updated")"
    done

    __p_keys_write_config <<< "$updated"
}

function ___p_group_add() {
    local key_base="/.p/keys"
    local name="$1"
    shift

    if [ "${name:0:1}" != "@" ]; then
        __e "Group name must begin with \`@\`: $name"
        return 1
    fi

    local updated="$(__p_keys_read_config)"

    for arg in "$@"; do
        updated="$(jq ".groups[\"$name\"]+=[\"$arg\"]" <<< "$updated")"
    done

    __p_keys_write_config <<< "$updated"
}

function ___p_group_list() {
    local key_base="/.p/keys"
    local config="$(__p_keys_read_config)"

    for name in $(jq -r ".groups | keys[]" <<< "$config"); do
        echo "group: $name"
        for groupindex in $(jq -r ".groups[\"$name\"] | keys[]" <<< "$config"); do
            local value="$(jq -r ".groups[\"$name\"][$groupindex]" <<< "$config")"
            echo "  member: $value"
            names+=("$value")
        done
    done
}

function ___p_group_remove() {
    local key_base="/.p/keys"
    local name="$1"
    shift

    if [ "${name:0:1}" != "@" ]; then
        __e "Group name must begin with \`@\`: $name"
        return 1
    fi

    local updated="$(__p_keys_read_config)"

    for arg in "$@"; do
        updated="$(jq ".groups[\"$name\"]-=[\"$arg\"]" <<< "$updated")"
    done

    __p_keys_write_config <<< "$updated"
}

function ___p_group_delete() {
    local key_base="/.p/keys"
    local name="$1"

    if [ "${name:0:1}" != "@" ]; then
        __e "Group name must begin with \`@\`: $name"
        return 1
    fi

    local config="$(__p_keys_read_config)"
    local updated="$(jq "del(.groups[\"$name\"])" <<< "$config")"

    __p_keys_write_config <<< "$updated"
}
