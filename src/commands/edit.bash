# Passthrough function for pass edit. Currently ignores $_p_cwd.
function ___p_edit() {
    local file="$(__p_find_file "$1")"
    local is_help="false"
    if [ "x$1" == "x--help" ] || [ "x$1" == "x-help" ] ||
            [ "x$1" == "x-h" ] || [ "x$1" == "x" ]; then
        is_help="true"
    fi

    if [ $# == 1 ] && [ "$is_help" == "false" ]; then
        if [ "x$file" != "x" ]; then
            ___p_open "$file" -- "$_p_editor"
        else
            __pass edit "$1"
        fi
    else
        echo "Usage: p edit <file>"
        echo ""
        echo "<file>: path or cwd-relative path to a file tracked by pass"
    fi
}
