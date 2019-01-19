function ___p_through() {
    __v "Value of _pc_through: $_pc_through"
    if [ "$_pc_through" == "false" ]; then
        return 0
    fi

    __pass "$@"
}
