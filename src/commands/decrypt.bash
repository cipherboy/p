function ___p_decrypt() {
    local entry="$1"
    local result_path="$2"

    ___p_decrypt_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    if [ -z "$result_path" ] || [ "$result_path" == "-" ]; then
        __pass show "$entry"
    else
        __pass show "$entry" > "$result_path"
    fi
}
