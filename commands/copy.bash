function ___p_copy() {
    __v "Value of _pc_copy: $_pc_copy"
    if [ "$_pc_copy" == "false" ]; then
        return 0
    fi

    __pass cp "$@"
}
