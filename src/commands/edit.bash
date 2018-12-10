# Passthrough function for pass edit. Currently ignores $_p_cwd.
function ___p_edit() {
    __v "Value of _pc_edit: $_pc_edit"
    if [ "$_pc_edit" == "false" ]; then
        return 0
    fi

    __pass edit "$@"
}
