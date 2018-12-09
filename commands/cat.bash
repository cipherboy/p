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
            local arg_path="$(__p_path_simplify "/$arg")"
            local arg_cwd_path="$(__p_path_simplify "$_p_cwd/$arg")"
            if [ -e "$_p_pass_dir/$arg_cwd_path.gpg" ]; then
                cat_targets+=("$arg_cwd_path")
            elif [ -e "$_p_pass_dir/$arg_path.gpg" ]; then
                cat_targets+=("$arg_path")
            else
                if [ "x$arg_path" != "x$arg_cwd_path" ]; then
                    __d "Unknown argument, path not found, or not a" \
                        "file: '$arg_path' and '$arg_cwd_path'." \
                        "If the path is a directory, note that \`p\` " \
                        "differs from \`pass\` in that the \`cat\`" \
                        "command will not show directories."
                else
                    __d "Unknown argument, path not found, or not a" \
                        "file: '$arg_path'. If the path is a directory," \
                        " note that \`p\` differs from \`pass\` in that" \
                        "the \`cat\` command will not show directories."
                fi
            fi
        fi
    done

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
