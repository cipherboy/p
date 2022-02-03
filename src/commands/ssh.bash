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

    pushd "$tmpdir" >/dev/null
        ___p_decrypt "$identity" "$tmp"
        ret=$?
    popd >/dev/null

    if (( ret == 0 )); then
        ssh -i "$tmp" "$host" "${ssh_args[@]}"
        ret=$?
    fi

    __p_rm_secure_tmp "$tmp"
    return $ret
}
