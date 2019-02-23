function ___p_encrypt() {
    local path="$1"
    local entry="$2"

    if (( $# != 2 )); then
        echo "Usage: p encrypt <path> <name>"
        echo "Encrypt the file at <path> in the password store under <name>."
        echo ""
        echo "Note: <path> can be '-', in which case stdin will be encrypted."

        return 1
    fi

    if [ "x$path" != "x-" ]; then
        __pass insert --multiline "$entry" < "$path" >/dev/null
    else
        __pass insert --multiline "$entry" >/dev/null
    fi
}
