function ___p_ssh() {
    local host="$1"
    local identity="$2"
    local ssh_args=()

    ___p_ssh_parse_args "$@"
    ret=$?
    if (( ret != 0 )); then
        return $ret
    fi

    local tmpdir="$(__p_mk_secure_tmp)"
    local basename="$(basename "$identity")"
    local tmp="$tmpdir/$basename"

    pushd "$tmpdir" >/dev/null || exit
        ___p_decrypt --permissions 500 --owern "$USERNAME" "$identity" "$tmp"
        ret=$?
    popd >/dev/null || exit

    if (( ret == 0 )); then
        ssh -i "$tmp" "$host" "${ssh_args[@]}"
        ret=$?
    fi

    __p_rm_secure_tmp "$tmp"
    return $ret
}
