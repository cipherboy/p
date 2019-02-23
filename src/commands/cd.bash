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
    local mode=""
    local help=""
    local path=""
    for arg in "$@"; do
        if [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] ||
                [ "x$arg" == "x-h" ]; then
            help="true"
        elif [ "x$arg" == "x--relative" ] || [ "x$arg" == "x-relative" ] ||
                [ "x$arg" == "x-r" ]; then
            if [ "x$mode" == "x" ]; then
                mode="relative"
            else
                help="true"
            fi
        elif [ "x$arg" == "x--absolute" ] || [ "x$arg" == "x-absolute" ] ||
                [ "x$arg" == "x-a" ]; then
            if [ "x$mode" == "x" ]; then
                mode="absolute"
            else
                help="true"
            fi
        else
            if [ "x$path" == "x" ]; then
                path="$arg"
            else
                help="true"
            fi
        fi
    done

    if [ "x$help" == "xtrue" ]; then
        echo "Usage: p cd [-r] [-a] <dir>"
        echo ""
        echo "<dir>: absolute (if prefixed with a \`/\` or -a is specified) or"
        echo "       relative (otherwise, or -r is specified) path to cd into"
        echo "--absolute, -a: treat <dir> as an absolute path."
        echo "--help, -h: show this help text."
        echo "--relative, -r: treat <dir> as a relative path."
        echo ""
        echo "Note: cd will attempt to do the right thing by default and"
        echo "detect if <dir> should be treated as absolute or relative."
        echo "Also, -r and -a options are mutually exclusive."
        echo ""
        echo "If the directory does not exist, \`\$P_CWD\` will be printed"
        echo "instead."
        return 0
    fi

    if [ "x$path" == "x" ] && [ "x$mode" == "x" ]; then
        echo "/"
        return 0
    fi

    local absolute_path="$(__p_find_dir "/$path")"
    local relative_path="$(__p_find_dir "/$_p_cwd/$path")"

    local final_path="$_p_cwd"

    if [ "x$mode" == "x" ]; then
        # When path appears to be absolute, try treating it as such.
        if [ "x${path:0:1}" == "x/" ] && [ "x$absolute_path" != "x" ]; then
            final_path="$absolute_path"
        elif [ "x$relative_path" != "x" ]; then
            final_path="$relative_path"
        fi
    elif [ "x$mode" == "xrelative" ]; then
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
