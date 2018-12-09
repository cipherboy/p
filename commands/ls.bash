# ls with optional respect to $P_CWD
#
# Supports the -d and -a parameters from ls; -a shows .gpg-id and
# .gpg suffix as well.
function ___p_ls() {
    __v "Value of _pc_ls: $_pc_ls"
    if [ "$_pc_ls" == "false" ]; then
        return 0
    fi

    local ls_dir="false"
    local ls_all="false"
    local ls_targets=()
    local ls_target_count=0

    for arg in "$@"; do
        if [ "x$arg" == "x--all" ] || [ "x$arg" == "x-all" ] ||
                [ "x$arg" == "x-a" ]; then
            ls_all="true"
        elif [ "x$arg" == "x--directory" ] || [ "x$arg" == "x--dir" ] ||
                [ "x$arg" == "x-directory" ] || [ "x$arg" == "x-dir" ] ||
                [ "x$arg" == "x-d" ]; then
            ls_dir="true"
        else
            local arg_path="$(__p_path_simplify "/$arg")"
            local arg_cwd_path="$(__p_path_simplify "$_p_cwd/$arg")"
            if [ -e "$_p_pass_dir/$arg_cwd_path" ]; then
                ls_targets+=("$arg_cwd_path")
            elif [ -e "$_p_pass_dir/$arg_path" ]; then
                ls_targets+=("$arg_path")
            else
                if [ "x$arg_path" != "x$arg_cwd_path" ]; then
                    __d "Unknown argument, path not found, or not a" \
                        "directory: '$arg_path' and '$arg_cwd_path'." \
                        "If the path is an encrypted item, note that" \
                        " \`p\` differs from \`pass\` in that the " \
                        "\`ls\` command will not show encrypted secrets."
                else
                    __d "Unknown argument, path not found, or not a" \
                        "directory: '$arg_path'. If the path is an" \
                        "encrypted item, note that \`p\` differs from" \
                        "\`pass\` in that the \`ls\` command will not" \
                        "show encrypted secrets."
                fi
            fi
        fi
    done

    ls_target_count="${#ls_targets[@]}"

    # If we have no targets but P_CWD specified, act as if that is our
    # single argument.
    if [ "$ls_target_count" == "0" ] && [ "$_p_cwd" != "/" ]; then
        ls_targets+=("$_p_cwd")
        ls_target_count=1
    fi

    if [ "$ls_dir" == "false" ] && [ "$ls_all" == "false" ]; then
        if [ "$ls_target_count" == "0" ]; then
            __pass ls
        else
            # pass lacks support for showing multiple directories;
            # emulate this by passing each one individually.
            for path in "${ls_targets[@]}"; do
                if [ "$path" == "/" ]; then
                    __pass ls
                    echo ""
                else
                    __pass ls "$path"
                    echo ""
                fi
            done
        fi
    elif [ "$ls_dir" == "false" ] && [ "$ls_all" == "true" ]; then
        # All mode is equivalent to a raw "tree" command, without
        # filtering the .gpg-id files and .gpg suffix. We also correctly
        # show the target directory in color. ;-)
        if [ "$ls_target_count" == "0" ]; then
            tree -I ".git" -a -C "$_p_pass_dir"
        else
            for path in "${ls_targets[@]}"; do
                if [ "$path" == "/" ]; then
                    tree -I ".git" -a -C "$_p_pass_dir"
                else
                    tree -I ".git" -a -C "$_p_pass_dir/$path"
                fi
            done
        fi
    elif [ "$ls_dir" == "true" ] && [ "$ls_all" == "false" ]; then
        # When we're in dir mode, only show the directories and prefer
        # colors. `tree` does this best, so best to defer to it.
        pushd "$_p_pass_dir" >/dev/null
            if [ "$ls_target_count" == "0" ]; then
                echo "Password Store"
                tree -d -C -l --noreport "$_p_pass_dir" | tail -n +2
            else
                for path in "${ls_targets[@]}"; do
                    if [ "$path" == "/" ]; then
                        echo "Password Store"
                        tree -d -C -l --noreport "$_p_pass_dir" | tail -n +2
                        echo ""
                    else
                        __dir "$path"
                        tree -d -C -l --noreport "$_p_pass_dir/$path" | tail -n +2
                        echo ""
                    fi
                done
            fi
        popd >/dev/null
    else
        __d "Current mode ls_dir:$ls_dir,ls_all:$ls_all unsupported!"
    fi
}
