function ___p_clone() {
    local uri=""

    ___p_clone_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    git clone "$uri" "$_p_pass_dir"
}
