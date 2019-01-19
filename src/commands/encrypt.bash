function ___p_encrypt() {
    __v "Value of _pc_encrypt: $_pc_encrypt"
    if [ "$_pc_encrypt" == "false" ]; then
        return 0
    fi

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
        __pass insert --multiline "$entry" < "$path"
    else
        __pass insert --multiline "$entry"
    fi
}
