function ___p_decrypt() {
    local entry="$1"
    local result_path="$2"

    if [ "x$_p_remote_host" != "x" ]; then
        ___p_remote_decrypt "$@"
        ret=$?

        return $?
    fi

    ___p_decrypt_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    if [ -z "$result_path" ] || [ "x$result_path" == "x-" ]; then
        __pass show "$entry"
    else
        __pass show "$entry" > "$result_path"
    fi
}

function ___p_remote_decrypt() {
    local args=("-q" "-t")
    if [ "x$_p_remote_port" != "x" ]; then
        args+=("-p" "$_p_remote_port")
    fi
    args+=("$_p_remote_user@$_p_remote_host")

    ssh "${args[@]}" -- p decrypt "$@"
}
