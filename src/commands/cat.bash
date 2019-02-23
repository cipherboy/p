# cat with optional respect to $P_CWD
#
# Supports formatting and optionally colorizing the result with jq.
function ___p_cat() {
    __v "Value of _pc_cat: $_pc_cat"
    if [ "$_pc_cat" == "false" ]; then
        return 0
    fi

    local cat_raw="false"
    local cat_show_password="true"
    local cat_show_json="true"
    local cat_colorize="true"
    local cat_targets=()

    for arg in "$@"; do
        if [ "x$arg" == "x--raw" ] || [ "x$arg" == "x-raw" ] ||
                [ "x$arg" == "x-r" ]; then
            cat_raw="true"
        elif [ "x$arg" == "x--json-only" ] || [ "x$arg" == "x-json-only" ] ||
                [ "x$arg" == "x--json" ] || [ "x$arg" == "x-json" ] ||
                [ "x$arg" == "x-j" ]; then
            cat_show_password="false"
            cat_show_json="true"
        elif [ "x$arg" == "x--password-only" ] ||
                [ "x$arg" == "x-password-only" ] ||
                [ "x$arg" == "x--password" ] ||
                [ "x$arg" == "x-password" ] ||
                [ "x$arg" == "x-p" ]; then
            cat_show_password="true"
            cat_show_json="false"
        elif [ "x$arg" == "x--no-color" ] || [ "x$arg" == "x-n-color" ] ||
                [ "x$arg" == "x-n" ]; then
            cat_colorize="false"
        else
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
        local content="$(__pass show "$target")"
        if [ "$cat_raw" == "false" ]; then
            local first_line="$(head -n 1 <<< "$content")"
            local rest="$(tail -n +2 <<< "$content")"

            # Check if the entire contents are json
            __jq . >/dev/null 2>/dev/null <<< "$content"
            local is_content_json="$?"

            # Check if the remaining contents are json
            __jq . >/dev/null 2>/dev/null <<< "$rest"
            local is_rest_json="$?"

            if [ "$cat_show_password" == "true" ] &&
                    [ "$cat_show_json" == "true" ]; then
                if (( is_content_json == 0 )); then
                    if [ "$cat_colorize" == "true" ]; then
                        __jq -C -S <<< "$content"
                    else
                        echo "$content"
                    fi
                elif (( is_rest_json == 0 )); then
                    echo "$first_line"
                    if [ "$cat_colorize" == "true" ]; then
                        __jq -C -S <<< "$rest"
                    else
                        echo "$rest"
                    fi
                else
                    echo "$content"
                fi
            elif [ "$cat_show_password" == "true" ] &&
                    [ "$cat_show_json" == "false" ]; then
                if (( is_rest_json == 0 )); then
                    echo "$first_line"
                elif (( is_content_json != 0 )); then
                    echo "$content"
                fi
            elif [ "$cat_show_password" == "false" ] &&
                    [ "$cat_show_json" == "true" ]; then
                if (( is_content_json == 0 )); then
                    if [ "$cat_colorize" == "true" ]; then
                        __jq -C -S <<< "$content"
                    else
                        echo "$content"
                    fi
                elif (( is_rest_json == 0 )); then
                    if [ "$cat_colorize" == "true" ]; then
                        __jq -C -S <<< "$rest"
                    else
                        echo "$rest"
                    fi
                fi
            fi
        elif [ "$cat_raw" == "true" ]; then
            echo "$content"
        fi
    done
}
