function ___p_encrypt() {
    local file_path=""
    local entry=""

    if [ "x$_p_remote_host" != "x" ]; then
        ___p_remote_encrypt "$@"
        ret=$?

        return $?
    fi

    ___p_encrypt_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    if [ "x$file_path" != "x-" ]; then
        __pass insert --multiline "$entry" < "$file_path" >/dev/null
    else
        __pass insert --multiline "$entry" >/dev/null
    fi
}

function ___p_remote_encrypt() {
    local args=("-q" "-t")
    if [ "x$_p_remote_port" != "x" ]; then
        args+=("-p" "$_p_remote_port")
    fi
    args+=("$_p_remote_user@$_p_remote_host")

    ssh "${args[@]}" -- p encrypt "$@"
}
