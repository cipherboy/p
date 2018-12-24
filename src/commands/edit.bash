# Passthrough function for pass edit. Currently ignores $_p_cwd.
function ___p_edit() {
    __v "Value of _pc_edit: $_pc_edit"
    if [ "$_pc_edit" == "false" ]; then
        return 0
    fi

    local file="$(__p_find_file "$1")"
    local is_help="false"
    if [ "x$1" == "x--help" ] || [ "x$1" == "x-help" ] ||
            [ "x$1" == "x-h" ] || [ "x$1" == "x" ]; then
        is_help="true"
    fi

    if [ $# == 1 ] && [ "$is_help" == "false" ]; then
        if [ "x$file" != "x" ]; then
            __pass edit "$file"
        else
            __pass edit "$1"
        fi
    else
        echo "Usage: p edit <file>"
        echo ""
        echo "<file>: path or cwd-relative path to a file tracked by pass"
    fi
}
