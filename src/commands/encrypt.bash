function ___p_encrypt() {
    local file_path=""
    local entry=""

    ___p_encrypt_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    if [ "$file_path" != "-" ]; then
        __pass insert --multiline "$entry" < "$file_path" >/dev/null
    else
        __pass insert --multiline "$entry" >/dev/null
    fi
}
