function ___p_rm() {
    __v "Value of _pc_rm: $_pc_rm"
    if [ "$_pc_rm" == "false" ]; then
        return 0
    fi

    __pass rm "$@"
}
