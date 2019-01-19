function ___p_mv() {
    __v "Value of _pc_mv: $_pc_mv"
    if [ "$_pc_mv" == "false" ]; then
        return 0
    fi

    __pass mv "$@"
}
