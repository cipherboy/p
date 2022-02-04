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

    if [ -z "$cd_path" ] && [ -z "$cd_mode" ]; then
        echo "/"
        return 0
    fi

    local absolute_path="$(__p_find_dir "/$cd_path")"
    local relative_path="$(__p_find_dir "/$_p_cwd/$cd_path")"

    local final_path="$_p_cwd"

    if [ -z "$cd_mode" ]; then
        # When path appears to be absolute, try treating it as such.
        if [ "${path:0:1}" == "/" ] && [ -n "$absolute_path" ]; then
            final_path="$absolute_path"
        elif [ -n "$relative_path" ]; then
            final_path="$relative_path"
        fi
    elif [ "$cd_mode" == "relative" ]; then
        if [ -n "$relative_path" ]; then
            final_path="$relative_path"
        fi
    else
        if [ -n "$absolute_path" ]; then
            final_path="$absolute_path"
        fi
    fi

    __v "Relative path: $relative_path"
    __v "Absolute path: $absolute_path"
    __v "Current path: $_p_cwd"

    echo "$final_path"
}
