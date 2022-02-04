function ___p_dirs() {
    local dirs_cmd=""

    ___p_dirs_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    ___p_dirs_dispatch_subparser
}

function ___p_dir_create() {
    local dir_path=""
    local dir_keys=()

    ___p_dirs_create_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    if [ "${dir:0:1}" != "/" ]; then
        __e "Directory name must begin with \`/\`: $dir"
        return 1
    fi

    local config="$(__p_keys_read_config)"

    local updated="$(jq ".dirs[\"$dir\"]=[]" <<< "$config")"

    for arg in "${dir_keys[@]}"; do
        updated="$(jq ".dirs[\"$dir\"]+=[\"$arg\"]" <<< "$updated")"
    done

    __p_keys_write_config <<< "$updated"
}

function ___p_dir_add() {
    local dir="$1"
    shift

    if [ "${dir:0:1}" != "/" ]; then
        __e "Directory name must begin with \`/\`: $dir"
        return 1
    fi

    local updated="$(__p_keys_read_config)"

    for arg in "$@"; do
        updated="$(jq ".dirs[\"$dir\"]+=[\"$arg\"]" <<< "$updated")"
    done

    __p_keys_write_config <<< "$updated"
}

function ___p_dir_list() {
    local config="$(__p_keys_read_config)"

    for dir in $(jq -r ".dirs | keys[]" <<< "$config"); do
        echo "dir: $dir"
        for dirindex in $(jq -r ".dirs[\"$dir\"] | keys[]" <<< "$config"); do
            local value="$(jq -r ".dirs[\"$dir\"][$dirindex]" <<< "$config")"
            echo "  member: $value"
            names+=("$value")
        done
    done
}

function ___p_dir_regen() {
    local dir="$1"
    shift

    if [ "${dir:0:1}" != "/" ]; then
        __e "Directory name must begin with \`/\`: $dir"
        return 1
    fi

    local config="$(__p_keys_read_config)"

    if [ ! -d "$_p_pass_dir/$dir" ]; then
        __e "Directory does not exist on disk: $dir"
        return 1
    fi

    if [ "$(jq -r ".dirs[\"$dir\"]" <<< "$config")" == "null" ]; then
        __e "Directory is not tracked by keys: $dir"
        return 1
    fi

    echo "Regenerating keys for \`$dir\`..."
    local path="$_p_pass_dir/$dir"
    local gpgid="$path/.gpg-id"

    local names=()

    rm "$gpgid" && touch "$gpgid"
    for index in $(jq -r ".dirs[\"$dir\"] | keys[]" <<< "$config"); do
        local name="$(jq -r ".dirs[\"$dir\"][$index]" <<< "$config")"
        names+=("$name")
    done

    while (( ${#names} > 0 )); do
        local name="${names[0]}"
        unset "names[0]"
        names=("${names[@]}")

        if [ "${name:0:1}" == "@" ]; then
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
    mapfile -t gpg_ids < "$gpgid"
    __pass init --path="$dir" "${gpg_ids[@]}"
}

function ___p_dir_remove() {
    local dir="$1"
    shift

    if [ "${dir:0:1}" != "/" ]; then
        __e "Directory name must begin with \`/\`: $dir"
        return 1
    fi

    local updated="$(__p_keys_read_config)"

    for arg in "$@"; do
        updated="$(jq ".dirs[\"$dir\"]-=[\"$arg\"]" <<< "$updated")"
    done

    __p_keys_write_config <<< "$updated"
}

function ___p_dir_delete() {
    local dir="$1"

    if [ "${dir:0:1}" != "/" ]; then
        __e "Directory path must begin with \`/\`: $dir"
        return 1
    fi

    local config="$(__p_keys_read_config)"
    local updated="$(jq "del(.dirs[\"$dir\"])" <<< "$config")"

    __p_keys_write_config <<< "$updated"
}
