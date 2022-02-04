# cat with optional respect to $P_CWD
#
# Supports formatting and optionally colorizing the result with jq.
function ___p_cat() {
    local cat_raw="false"
    local cat_json_only="false"
    local cat_password_only="false"
    local cat_colorize="true"
    local cat_paths=()

    ___p_cat_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    if [ ! -t 1 ]; then
        # Refuse to colorize when output is not a terminal; otherwise, `jq`
        # tends to throw errors...
        cat_colorize="false"
    fi

    if [ "$cat_password_only" == "true" ] &&
            [ "$cat_json_only" == "true" ]; then
        echo "Cannot specify both --password-only and --json-only" 1>&2
        return 1
    fi

    local cat_targets=()
    for path in "${cat_paths[@]}"; do
        local target="$(__p_find_file "$path")"
        if [ -z "$target" ]; then
            __d "Unknown argument, path not found, or not a file:" \
                "$path. If the path is a directory, note that \`p\` " \
                "differs from \`pass\` in that the \`cat\` command " \
                "will not show directories."
        fi
        cat_targets+=("$target")
    done

    for target in "${cat_targets[@]}"; do
        local content="$(___p_decrypt "$target" -)"
        if [ "$cat_raw" == "false" ]; then
            local first_line="$(head -n 1 <<< "$content")"
            local rest="$(tail -n +2 <<< "$content")"

            # Check if the entire contents are json
            __jq . >/dev/null 2>/dev/null <<< "$content"
            local is_content_json="$?"

            # Check if the remaining contents are json
            __jq . >/dev/null 2>/dev/null <<< "$rest"
            local is_rest_json="$?"

            if [ "$cat_password_only" == "false" ] &&
                    [ "$cat_json_only" == "false" ]; then
                if (( is_rest_json == 0 )); then
                    echo "$first_line"
                    if [ "$cat_colorize" == "true" ]; then
                        __jq -C -S <<< "$rest"
                    else
                        echo "$rest"
                    fi
                elif (( is_content_json == 0 )); then
                    if [ "$cat_colorize" == "true" ]; then
                        __jq -C -S <<< "$content"
                    else
                        echo "$content"
                    fi
                else
                    echo "$content"
                fi
            elif [ "$cat_password_only" == "true" ] &&
                    [ "$cat_json_only" == "false" ]; then
                if (( is_rest_json == 0 )); then
                    echo "$first_line"
                elif (( is_content_json != 0 )); then
                    echo "$content"
                fi
            elif [ "$cat_password_only" == "false" ] &&
                    [ "$cat_json_only" == "true" ]; then
                if (( is_rest_json == 0 )); then
                    if [ "$cat_colorize" == "true" ]; then
                        __jq -C -S <<< "$rest"
                    else
                        echo "$rest"
                    fi
                elif (( is_content_json == 0 )); then
                    if [ "$cat_colorize" == "true" ]; then
                        __jq -C -S <<< "$content"
                    else
                        echo "$content"
                    fi
                fi
            fi
        elif [ "$cat_raw" == "true" ]; then
            echo "$content"
        fi
    done
}
