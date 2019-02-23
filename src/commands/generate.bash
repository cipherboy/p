function ___p_generate() {
    local format=""
    local mode=""
    local name=""
    local help="false"

    while (( $# > 0 )); do
        local arg="$1"
        shift

        if [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] ||
                [ "x$arg" == "x-h" ]; then
            help="true"
        elif [ "x$arg" == "x--format" ] || [ "x$arg" == "x-format" ] ||
                [ "x$arg" == "x-f" ]; then
            if [ "x$mode" == "x" ]; then
                format="$1"
                shift

                mode="format"
            else
                __e "Multiple modes (--format, --random, or --phrase) used!"
                help="true"
            fi
        elif [ "x$arg" == "x--random" ] || [ "x$arg" == "x--rand" ] ||
                [ "x$arg" == "x-random" ] || [ "x$arg" == "x-rand" ] ||
                [ "x$arg" == "x-r" ]; then
            if [ "x$mode" == "x" ]; then
                mode="random"
            else
                __e "Multiple modes (--format, --random, or --phrase) used!"
                help="true"
            fi
        elif [ "x$arg" == "x--phrase" ] || [ "x$arg" == "x-phrase" ] ||
                [ "x$arg" == "x-p" ]; then
            if [ "x$mode" == "x" ]; then
                mode="phrase"
            else
                __e "Multiple modes (--format, --random, or --phrase) used!"
                help="true"
            fi
        elif [ "x$arg" == "x--save" ] || [ "x$arg" == "x-save" ] ||
                [ "x$arg" == "x-s" ]; then
            name="$1"
            shift
        fi
    done

    if [ "x$mode" == "x" ]; then
        mode="random"
    fi

    if [ "$help" == "true" ]; then
        echo "Usage: p generate [options]"
        echo "Generate a random password and optionally save it."
        echo ""
        echo "Options:"
        echo " --format, -f <string>: format string for password generation"
        echo " --phrase, -p: generate a pass phrase"
        echo " --random, -r: generate a random string"
        echo " --save, -s <name>: password store entry to save new password in"
        echo ""
        echo "Format string escape codes:"
        echo " \\c: a random alphanumeric character"
        echo " \\d: a random number"
        echo " \\l: a random lower case letter"
        echo " \\u: a random upper case letter"
        echo " \\w: a lower case word"
        echo " \\W: an upper case word"
        echo " \\\\: a literal '\\'"
        echo "All other characters are echoed as-is."
        echo ""
        echo "Note:"
        echo "When saving a password, the destination object must be a JSON" \
             "entry."

        return 1
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

    if [ "x$name" != "x" ]; then
        ___p_json set "$name" "password" "$password"
    fi
}
