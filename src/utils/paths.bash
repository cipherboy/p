# Join paths for handling by `pass`. This handles the following cases:
#
#   - leading '/'s
#   - `..` as a path segment
#   - `.` as a path segment
#
# Note that we cannot use `[ -d ... ]`, `readlink`, or `abspath` as the
# paths may not exist at this stage. Using python's os.path.abspath also
# isn't an option since it'd allow us to escape above the password-store
# directory and would require us to parse out the `pwd` prefix.
function __p_join() {
    local concated_path=""
    for arg in "$@"; do
        if [ "x$concated_path" == "x" ]; then
            concated_path="$arg"
        else
            concated_path="$concated_path/$arg"
        fi
    done

    __p_path_simplify "$concated_path"
}

# Simplify a path, echoing the result. Note that the path cannot exceed
# the passed depth:
#
#   ../../../ = /
#   a/../../ = /
#   a/b/../ = a/
#
# This is the internal version of the call that does most of the work;
# __p_path_simplify(path) calls __p_path_simplify_internal until the
# result is stable.
function __p_path_simplify_internal() {
    local path="$1"
    __v "    starting_path: $path"

    shopt -s extglob

    # Replace occurrences of 'dir/../' with ''
    current_path=""
    next_path="$path"
    while [ "x$current_path" != "x$next_path" ]; do
        __v "    1:current_path: $current_path"
        __v "    1:next_path: $next_path"
        current_path="$next_path"
        next_path="${current_path/*([^\/])\/..\//}"
    done

    # Replace occurrences of ^../ (../ at the beginning) with /
    current_path=""
    while [ "x$current_path" != "x$next_path" ]; do
        __v "    2:current_path: $current_path"
        __v "    2:next_path: $next_path"
        current_path="$next_path"
        next_path="${current_path/#..\//\/}"
    done

    # Replace occurrences of '/./' with '/'
    current_path=""
    while [ "x$current_path" != "x$next_path" ]; do
        __v "    3:current_path: $current_path"
        __v "    3:next_path: $next_path"
        current_path="$next_path"
        next_path="${current_path//\/.\//\/}"
    done

    # Replace occurrences of '#./' with '/'
    current_path=""
    while [ "x$current_path" != "x$next_path" ]; do
        __v "    4:current_path: $current_path"
        __v "    4:next_path: $next_path"
        current_path="$next_path"
        next_path="${current_path/#.\//\/}"
    done

    # Replace occurrences of '%/.' with '/'
    current_path=""
    while [ "x$current_path" != "x$next_path" ]; do
        __v "    4:current_path: $current_path"
        __v "    4:next_path: $next_path"
        current_path="$next_path"
        next_path="${current_path/%\/./\/}"
    done


    # Replace occurrences of '//' with '/'
    current_path=""
    while [ "x$current_path" != "x$next_path" ]; do
        __v "    5:current_path: $current_path"
        __v "    5:next_path: $next_path"
        current_path="$next_path"
        next_path="${current_path//\/\//\/}"
    done

    echo "$current_path"
}

# Note that this is not suitable to call on true file system paths,
# especially for destructive operations: the following construct "equals"
# '/' or the root, but isn't necessarily so:
#
#       a/b/c/d/../../../../../
#
# Answer is given on stdout. stderr is meaningless and contains random
# debug information in verbose mode.
function __p_path_simplify() {
    local current_path=""
    local next_path="$1"

    while [ "x$current_path" != "x$next_path" ]; do
        __v "current_path: $current_path"
        __v "next_path: $next_path"
        current_path="$next_path"
        next_path="$(__p_path_simplify_internal "$current_path")"
    done

    echo "$next_path"
}

# Find the referenced file; these end in .gpg
function __p_find_file() {
    local name="$1"

    local path="$(__p_path_simplify "/$name")"
    local cwd_path="$(__p_path_simplify "$_p_cwd/$name")"
    if [ -e "$_p_pass_dir/$cwd_path.gpg" ]; then
        echo "$cwd_path"
        return 0
    elif [ -e "$_p_pass_dir/$path.gpg" ]; then
        echo "$path"
        return 0
    fi

    return 1
}

# Find the referenced directory.
function __p_find_dir() {
    local name="$1"

    local path="$(__p_path_simplify "/$name")"
    local cwd_path="$(__p_path_simplify "$_p_cwd/$name")"
    if [ -e "$_p_pass_dir/$cwd_path" ]; then
        echo "$cwd_path"
        return 0
    elif [ -e "$_p_pass_dir/$path" ]; then
        echo "$path"
        return 0
    fi

    return 1
}
