function __p_is_remote() {
    [ "x$_p_remote_host" != "x" ]
}

function __p_remote() {
    local args=("-q" "-t")
    if [ "x$_p_remote_port" != "x" ]; then
        args+=("-p" "$_p_remote_port")
    fi
    args+=("$_p_remote_user@$_p_remote_host")

    ssh "${args[@]}" -- p "$@"
}

function __p_handle_remote() {
    __p_remote "${_p_remote_cmd_args[@]}"
}
