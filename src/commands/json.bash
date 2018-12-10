# Function for reading and editing JSON structure of files. Since pass
# has an unofficial format with the first line being the password, we
# must be careful to modify the first line to match the vlaue of password
# iff the password matches the present JSON value and we're updating it.
# Otherwise, we'll print a warning about what we're supposed to do.
#
# Remote execution requirements: this command must be executed on the
# remote host entirely.
function ___p_json() {
    __v "Value of _pc_json: $_pc_json"
    if [ "$_pc_json" == "false" ]; then
        return 0
    fi

    j_command="$1"
    j_file="$2"
    j_key="$3"
    j_value="$4"

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
            _pc_cat="true" ___p_cat --json-only "$j_file" | jq ".old_passwords=[.password]+.old_passwords|.password=\"$j_value\"" | __p_print_json | pass insert -m -f "$j_file"
        else
            _pc_cat="true" ___p_cat --json-only "$j_file" | jq ".$key=\"$j_value\"" | __p_print_json | pass insert -m -f "$j_file"
        fi
    else
        echo "Usage: p json <subcommand> <arguments>"
        echo ""
        echo "Subcommands:"
        echo "    get <file> <key> - read key from the file's JSON data"
        echo "    help - show this help text"
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
