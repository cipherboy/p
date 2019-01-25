function ___p_find() {
    __v "Value of _pc_find: $_pc_find"
    if [ "$_pc_find" == "false" ]; then
        return 0
    fi

    if (( $# == 0 )); then
        find "$_p_pass_dir" -name '.git' -prune -o -print | sed "s,^$_p_pass_dir[/],,g" | tail -n +2
    else
        find "$_p_pass_dir" -name '.git' -prune -o "$@" -print | sed "s,^$_p_pass_dir[/],,g"
    fi
}
