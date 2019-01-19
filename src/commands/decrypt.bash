function ___p_decrypt() {
    __v "Value of _pc_decrypt: $_pc_decrypt"
    if [ "$_pc_decrypt" == "false" ]; then
        return 0
    fi

    local entry="$1"
    local path="$2"

    if (( $# != 2 )); then
        echo "Usage: p decrypt <name> <path>"
        echo "Decrypt the entry <name> and store it at <path>."

        return 1
    fi

    __pass show "$entry" > "$path"
}
