function ___p_generate() {
    local format=""
    local mode="random"
    local name=""
    local help="false"

    ___p_generate_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    if [ -n "$format" ]; then
        mode="format"
    fi

    local password=""
    if [ "$mode" == "format" ]; then
        password="$(__genpass "$format")"
    elif [ "$mode" == "random" ]; then
        password="$(__genpass --random)"
    elif [ "$mode" == "phrase" ]; then
        password="$(__genpass --phrase)"
    fi

    cat - <<< "$password"

    if [ -n "$name" ]; then
        ___p_json set "$name" "password" "$password"
    fi
}
