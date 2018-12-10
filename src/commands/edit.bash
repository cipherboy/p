# Passthrough function for pass edit. Currently ignores $_p_cwd.
function ___p_edit() {
    __v "Value of _pc_edit: $_pc_edit"
    if [ "$_pc_edit" == "false" ]; then
        return 0
    fi

    local file="$(__p_find_file "$1")"

    if [ $# == 1 ] && [ "x$file" != "x" ]; then
        __pass edit "$file"
    else
        echo "Usage: p edit <file>"
        echo ""
        echo "<file>: path or cwd-relative path to a file tracked by pass"
    fi
}
