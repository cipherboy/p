# cat with optional respect to $P_CWD
#
# Supports formatting and optionally colorizing the result with jq.
function ___p_cat() {
    __v "Value of _pc_cat: $_pc_cat"
    if [ "$_pc_cat" == "false" ]; then
        return 0
    fi

    local cat_raw="false"
    local cat_json_only="false"
    local cat_colorize="true"
    local cat_targets=()

    for arg in "$@"; do
        if [ "x$arg" == "x--raw" ] || [ "x$arg" == "x-raw" ] ||
                [ "x$arg" == "-r" ]; then
            cat_raw="true"
        elif [ "x$arg" == "x--json-only" ] || [ "x$arg" == "x-json-only" ] ||
                [ "x$arg" == "x--json" ] || [ "x$arg" == "x-json" ] ||
                [ "x$arg" == "x-j" ]; then
            cat_json_only="true"
        elif [ "x$arg" == "x--no-color" ] || [ "x$arg" == "x-n-color" ] ||
                [ "x$arg" == "-n" ]; then
            cat_colorize="false"
        else
            __p_find_file "$arg"
            local arg_path="$(__p_find_file "$arg")"
            if [ "x$arg_path" != "x" ]; then
                cat_targets+=("$arg_path")
            else
                __d "Unknown argument, path not found, or not a file: " \
                    "$arg. If the path is a directory, note that \`p\` " \
                    "differs from \`pass\` in that the \`cat\` command " \
                    "will not show directories."
            fi
        fi
    done

    if [ ! -t 1 ]; then
        # Refuse to colorize when output is not a terminal; otherwise, `jq`
        # tends to throw errors...
        cat_colorize="false"
    fi

    for target in "${cat_targets[@]}"; do
        if [ "$cat_raw" == "false" ]; then
            local content="$(__pass show "$target")"
            local first_line="$(echo "$content" | head -n 1)"
            local rest="$(echo "$content" | tail -n +2)"

            # Check if the remaining contents are json
            echo "$rest" | __jq . >/dev/null 2>/dev/null
            local is_json="$?"

            if [ "$cat_json_only" == "false" ]; then
                echo "$first_line"
            fi
            if [ "$cat_colorize" == "true" ] && [ "$is_json" == "0" ]; then
                echo "$rest" | __jq -C -S
            else
                echo "$rest"
            fi
        else
            __pass show "$target"
        fi
    done
}
