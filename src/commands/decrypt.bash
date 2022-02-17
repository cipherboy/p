function ___p_decrypt() {
    local permissions="600"
    local owner="$(whoami)"
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
        __pass show "$entry" | install --mode="$permissions" --owner="$owner" /dev/stdin "$result_path"
    fi
}
