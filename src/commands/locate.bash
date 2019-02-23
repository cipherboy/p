function ___p_locate() {
    if (( $# == 0 )) || [ "x$1" == "x--help" ] ||
            [ "x$1" == "x-h" ]; then
        echo "Usage: p locate <substr> [ ... ]"
        echo "Locate vault entries with <substr> as part of the name. If"
        echo "multiple substrings are specified, will match any of them."

        return 1
    fi

    __pass find "$@"
}
