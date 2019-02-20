# Function for reading and editing JSON structure of files. Since pass
# has an unofficial format with the first line being the password, we
# must be careful to modify the first line to match the vlaue of password
# iff the password matches the present JSON value and we're updating it.
# Otherwise, we'll print a warning about what we're supposed to do.
#
# Remote execution requirements: this command must be executed on the
# remote host, except for retype-related commands.
function ___p_json() {
    __v "Value of _pc_json: $_pc_json"
    if [ "$_pc_json" == "false" ]; then
        return 0
    fi

    local j_command="$1"
    local j_file="$2"
    local j_key="$3"
    local j_value="$4"

    if [ "x$j_command" == "xget" ] && [ "x$j_file" != "x" ] &&
            (( $# >= 2 )) && (( $# <= 3 )); then

        # Perform get operation on file / key
        if [ "x$j_key" == "x" ]; then
            j_key="password"
        fi

        _pc_cat="true" ___p_cat --json-only "$j_file" | jq -r ".$j_key"
    elif [ "x$j_command" == "xset" ] && [ "x$j_file" != "x" ] &&
            (( $# == 4 )); then

        # Perform set operation on file / key = value
        if [ "x$j_key" == "xpassword" ]; then
            local json="$(_pc_cat="true" ___p_cat --json-only "$j_file")"

            jq ".old_passwords=[.password]+.old_passwords|.password=\"$j_value\"" <<< "$json" | __p_print_json | __pass insert -m -f "$j_file"
        else
            jq ".$j_key=\"$j_value\"" <<< "$json" | __p_print_json | __pass insert -m -f "$j_file"
        fi
    elif [ "x$j_command" = "xretype" ] && [ "x$j_file" != "x" ] &&
            (( $# >= 2 )) && (( $# <= 3 )); then

        # Similar to a get operation, perform a retype operation on the
        # file / key.
        if [ "x$j_key" == "x" ]; then
            j_key="password"
        fi

        local value="$(_pc_cat="true" ___p_cat --json-only "$j_file" | jq -r ".$j_key")"
        __rtypr "$value"
    elif [ "x$j_command" == "xkinit" ] && [ "x$j_file" != "x" ] &&
            (( $# == 2 )); then
        local file="$(_pc_cat="true" ___p_cat --json-only "$j_file")"

        local principal="$(jq -r ".principal" <<< "$file")"
        if [ "x$principal" == "x" ]; then
            principal="$(jq -r ".username" <<< "$file")"
        fi

        local password="$(jq -r ".password" <<< "$file")"

        kinit "$principal" <<< "$password"
    else
        echo "Usage: p json <subcommand> <arguments>"
        echo ""
        echo "Subcommands:"
        echo "    get <file> <key> - read key from the file's JSON data"
        echo "    help - show this help text"
        echo "    kinit <file> - perform kinit with credentials from the file"
        echo "    retype <file> <key> - retype the specified key from the file"
        echo "    set <file> <key> <value> - set the value of key in file"
        echo ""
        echo "Note:"
        echo "The underlying JSON is manipulated using \`jq\`. The filter"
        echo "is created of the form '.\$key=\"\$value\"'. Note that this"
        echo "filter is created in \`/dev/shm\` and passed to jq as a"
        echo "file."

        return 1
    fi
}
