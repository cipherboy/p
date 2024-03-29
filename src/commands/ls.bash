# ls with optional respect to $P_CWD
#
# Supports the -d and -a parameters from ls; -a shows .gpg-id and
# .gpg suffix as well.
function ___p_ls() {
    local ls_dir="false"
    local ls_all="false"
    local ls_targets=()
    local ls_target_count=0

    for arg in "$@"; do
        if [ "$arg" == "--all" ] || [ "$arg" == "-all" ] ||
                [ "$arg" == "-a" ]; then
            ls_all="true"
        elif [ "$arg" == "--directory" ] || [ "$arg" == "--dir" ] ||
                [ "$arg" == "-directory" ] || [ "$arg" == "-dir" ] ||
                [ "$arg" == "-d" ]; then
            ls_dir="true"
        else
            local arg_path="$(__p_exists "$arg" false)"

            if [ -n "$arg_path" ]; then
                ls_targets+=("$arg_path")
            else
                __e "Unknown argument or path not found: '$arg'."
                return 1
            fi
        fi
    done

    ls_target_count="${#ls_targets[@]}"

    # If we have no targets, set one: $_p_cwd (defaults to /).
    if (( ls_target_count == 0 )); then
        ls_targets+=("$_p_cwd")
        ls_target_count=1
    fi

    if [ "$ls_dir" == "false" ] && [ "$ls_all" == "false" ]; then
        # pass lacks support for showing multiple directories;  emulate
        # this by passing each one individually.
        for path in "${ls_targets[@]}"; do
            if [ "$path" == "/" ]; then
                __pass ls
                echo ""
            elif __p_is_file "$path"; then
                echo "$path"
            else
                __p_dir "$path"
                __pass ls "$path" | tail -n +2
                echo ""
            fi
        done
    elif [ "$ls_dir" == "false" ] && [ "$ls_all" == "true" ]; then
        # All mode is equivalent to a raw "tree" command, without
        # filtering the .gpg-id files and .gpg suffix. We also correctly
        # show the target directory in color. ;-)
        for path in "${ls_targets[@]}"; do
            if [ "$path" == "/" ]; then
                tree -I ".git" -a -C "$_p_pass_dir"
            elif __p_is_file "$path"; then
                echo "$path.gpg"
            else
                tree -I ".git" -a -C "$_p_pass_dir/$path"
            fi
        done
    elif [ "$ls_dir" == "true" ] && [ "$ls_all" == "false" ]; then
        # When we're in dir mode, only show the directories and prefer
        # colors. `tree` does this best, so best to defer to it.
        pushd "$_p_pass_dir" >/dev/null || exit
            for path in "${ls_targets[@]}"; do
                if [ "$path" == "/" ]; then
                    echo "Password Store"
                    tree -d -C -l --noreport "$_p_pass_dir" | tail -n +2
                    echo ""
                elif __p_is_file "$path"; then
                    echo "$path.gpg"
                else
                    __p_dir "$path"
                    tree -d -C -l --noreport "$_p_pass_dir/$path" | tail -n +2
                    echo ""
                fi
            done
        popd >/dev/null || exit
    else
        __d "Current mode ls_dir:$ls_dir,ls_all:$ls_all unsupported!"
    fi
}
