# Function to change directories. Note that, as p is usually invoked from a
# new bash process, a function usually has to be created to actually change
# directories:
#
# function pcd() {
#   export P_CWD="$(p cd "$1")"'
# }
function ___p_cd() {
    # Mode is a variable which defines the mode for interpreting the path
    # argument to cd: auto, relative, or absolute.
    local cd_mode=""
    local cd_path=""

    ___p_cd_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    if [ "x$cd_path" == "x" ] && [ "x$cd_mode" == "x" ]; then
        echo "/"
        return 0
    fi

    local absolute_path="$(__p_find_dir "/$cd_path")"
    local relative_path="$(__p_find_dir "/$_p_cwd/$cd_path")"

    local final_path="$_p_cwd"

    if [ "x$cd_mode" == "x" ]; then
        # When path appears to be absolute, try treating it as such.
        if [ "x${path:0:1}" == "x/" ] && [ "x$absolute_path" != "x" ]; then
            final_path="$absolute_path"
        elif [ "x$relative_path" != "x" ]; then
            final_path="$relative_path"
        fi
    elif [ "x$cd_mode" == "xrelative" ]; then
        if [ "x$relative_path" != "x" ]; then
            final_path="$relative_path"
        fi
    else
        if [ "x$absolute_path" != "x" ]; then
            final_path="$absolute_path"
        fi
    fi

    __v "Relative path: $relative_path"
    __v "Absolute path: $absolute_path"
    __v "Current path: $_p_cwd"

    echo "$final_path"
}
