function ___p_search() {
    __v "Value of _pc_search: $_pc_search"
    if [ "$_pc_search" == "false" ]; then
        return 0
    fi

    __pass grep "$@"
}
