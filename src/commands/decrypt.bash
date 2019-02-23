function ___p_decrypt() {
    local entry="$1"
    local path="$2"

    if (( $# != 2 )); then
        echo "Usage: p decrypt <name> <path>"
        echo "Decrypt the entry <name> and store it at <path>."
        echo ""
        echo "Note: <path> can be '-', in which case <name> will be written" \
             "to stdout."

        return 1
    fi

    if [ "x$path" != "x-" ]; then
        __pass show "$entry" > "$path"
    else
        __pass show "$entry"
    fi
}
