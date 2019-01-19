function ___p_cp() {
    __v "Value of _pc_cp: $_pc_cp"
    if [ "$_pc_cp" == "false" ]; then
        return 0
    fi

    __pass cp "$@"
}
