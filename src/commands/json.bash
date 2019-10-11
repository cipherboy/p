# Function for reading and editing JSON structure of files. Since pass
# has an unofficial format with the first line being the password, we
# must be careful to modify the first line to match the vlaue of password
# iff the password matches the present JSON value and we're updating it.
# Otherwise, we'll print a warning about what we're supposed to do.
#
# Remote execution requirements: this command must be executed on the
# remote host, except for retype-related commands.
function ___p_json() {
    local json_cmd=""
    local json_cmd_args=()

    ___p_json_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    ___p_json_dispatch_subparser
}

function ___p_json_get() {
    local j_file=""
    local j_key="password"

    ___p_json_get_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    ___p_cat --json-only "$j_file" | jq -r ".$j_key"
}

function ___p_json_set() {
    local j_file=""
    local j_key="password"
    local j_value=""

    ___p_json_set_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    if ! __p_lock "$j_file"; then
        __e "Lock for $j_file held by another program."
        return 1
    fi
    local json="$(___p_cat --json-only "$j_file")"

    # Perform set operation on file / key = value
    if [ "x$j_key" == "xpassword" ]; then
        jq ".old_passwords=[.password]+.old_passwords|.password=\"$j_value\"" <<< "$json" | __p_print_json | ___p_encrypt - "$j_file"
    else
        jq ".$j_key=\"$j_value\"" <<< "$json" | __p_print_json | ___p_encrypt - "$j_file"
    fi
    __p_unlock "$j_file"
}

function ___p_json_retype() {
    local j_file=""
    local j_key="password"

    ___p_json_retype_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    # Similar to a get operation, perform a retype operation on the
    # file / key.
    if [ "x$j_key" == "x" ]; then
        j_key="password"
    fi

    local value="$(___p_cat --json-only "$j_file" | jq -r ".$j_key")"
    __rtypr "$value"
}

function ___p_json_kinit() {
    local j_file=""

    ___p_json_kinit_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    local file="$(___p_cat --json-only "$j_file")"

    local principal="$(jq -r ".principal" <<< "$file")"
    if [ "x$principal" == "x" ]; then
        principal="$(jq -r ".username" <<< "$file")"
    fi

    local password="$(jq -r ".password" <<< "$file")"
    kinit "$principal" <<< "$password"
}
