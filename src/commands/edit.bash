# Passthrough function for pass edit. Currently ignores $_p_cwd.
function ___p_edit() {
    local edit_path=""

    ___p_edit_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    local file="$(__p_find_file "$1")"
    if [ "x$file" != "x" ]; then
        ___p_open "$file" -- "$_p_editor"
    else
        __pass edit "$edit_path"
    fi
}
