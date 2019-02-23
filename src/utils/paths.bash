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

    # Replace occurrences of '//' with '/'
    current_path=""
    next_path="$path"
    while [ "x$current_path" != "x$next_path" ]; do
        __v "    5:current_path: $current_path"
        __v "    5:next_path: $next_path"
        current_path="$next_path"
        next_path="${current_path//\/\//\/}"
    done

    # Replace occurrences of 'dir/../' with ''
    current_path=""
    while [ "x$current_path" != "x$next_path" ]; do
        __v "    1:current_path: $current_path"
        __v "    1:next_path: $next_path"
        current_path="$next_path"
        next_path="${current_path/+([^\/])\/..\//}"
    done

    # Replace occurrences of ^../ (../ at the beginning) with /
    current_path=""
    while [ "x$current_path" != "x$next_path" ]; do
        __v "    2:current_path: $current_path"
        __v "    2:next_path: $next_path"
        current_path="$next_path"
        next_path="${current_path/#..\//\/}"
    done

    # Replace occurrences of ^/../ with /
    current_path=""
    while [ "x$current_path" != "x$next_path" ]; do
        __v "    2:current_path: $current_path"
        __v "    2:next_path: $next_path"
        current_path="$next_path"
        next_path="${current_path/#\/..\//\/}"
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

function __p_exists() {
    local name="$1"
    local path="$(__p_path_simplify "/$name")"
    local cwd_path="$(__p_path_simplify "$_p_cwd/$name")"

    local first_char="${name:0:1}"
    if [ "x$first_char" == "x/" ]; then
        # This path is absolute; treat it as coming from the root of the
        # password store.
        if [ -e "$_p_pass_dir/$path.gpg" ]; then
            echo "$path"
            return 0
        elif [ -e "$_p_pass_dir/$path" ]; then
            echo "$path"
            return 0
        fi
    elif [ "x$first_char" == "x." ]; then
        # This path is relative; treat it as coming relative to cwd.
        if [ -e "$_p_pass_dir/$cwd_path.gpg" ]; then
            echo "$cwd_path"
            return 0
        elif [ -e "$_p_pass_dir/$cwd_path" ]; then
            echo "$cwd_path"
            return 0
        fi
    else
        # Assume we're relative to $_p_cwd first, then try an absolute
        # path.
        if [ -e "$_p_pass_dir/$cwd_path.gpg" ]; then
            echo "$cwd_path"
            return 0
        elif [ -e "$_p_pass_dir/$cwd_path" ]; then
            echo "$cwd_path"
            return 0
        elif [ -e "$_p_pass_dir/$path.gpg" ]; then
            echo "$path"
            return 0
        elif [ -e "$_p_pass_dir/$path" ]; then
            echo "$path"
            return 0
        fi
    fi

    # Path wasn't found -- let's try a fuzzy match.
    mapfile -t paths < <(find "$_p_pass_dir" -printf "%P\n" | sort)

    cwd_results=()
    relative_results=()
    name_results=()

    for path in "${paths[@]}"; do
        if [[ "$path" == ".git"* ]] || [[ "$path" == ".p"* ]] ||
                [[ "$path" == *".gpg-id" ]]; then
            continue
        fi

        # Hide .gpg identifier
        path="${path%.gpg}"

        # Basename of file
        local basename="${path##*/}"

        if [[ "$path" == *$name* ]]; then
            relative_results+=("$path")
            if [[ "$path" == "$cwd_path"* ]]; then
                cwd_results+=("$path")
            fi
        fi

        if [[ "$basename" == *$name* ]]; then
            name_results+=("$path")
        fi
    done

    if (( ${#cwd_results[@]} == 1 )); then
        echo "${cwd_results[0]}"
        return 0
    elif (( ${#relative_results[@]} == 1 )); then
        echo "${relative_results[0]}"
        return 0
    elif (( "${#name_results[@]}" == 1 )); then
        echo "${name_results[0]}"
        return 0
    fi

    for path in "${relative_results[@]}"; do
        __e "$path"
    done
    return 1
}

# Find the referenced file; these end in .gpg.
function __p_find_file() {
    local name="$1"
    local path=""
    local ret=0

    path="$(__p_exists "$name")"
    ret=$?

    if (( ret == 0 )) && [ -e "$_p_pass_dir/$path.gpg" ]; then
        echo "$path"
        return 0
    fi

    return 1
}

# Find the referenced directory.
function __p_find_dir() {
    local name="$1"
    local path=""
    local ret=0

    path="$(__p_exists "$name")"
    ret=$?

    if (( ret == 0 )) && [ -e "$_p_pass_dir/$path" ]; then
        echo "$path"
        return 0
    fi

    return 1
}

# Check if a given path is a file.
function __p_is_file() {
    local name="$1"
    __p_find_file "$name" >/dev/null
}

# Check if a given path is a directory.
function __p_is_dir() {
    local name="$1"
    __p_find_dir "$name" >/dev/null
}

# Create a user-owned private temporary directory.
function __p_mk_secure_tmp() {
    local tmp_base="$TMPDIR"

    local user_id="$(id --user --real)"
    local group_id="$(id --group --real)"

    if [ "x$tmp_base" == "x" ] && [ -d "/run/user/$user_id" ]; then
        tmp_base="/run/user/$user_id"
    elif [ "x$tmp_base" == "x" ] && [ -d /dev/shm ]; then
        tmp_base="/dev/shm"
    elif [ "x$tmp_base" == "x" ] && [ -d "$HOME/tmp" ]; then
        tmp_base="$HOME/tmp"
    else
        tmp_base="/tmp"
    fi

    tmp_base="$tmp_base/p-password-store-$user_id"
    __v "Using tmp_base=\"$tmp_base\""

    if [ ! -d "$tmp_base" ]; then
        mkdir "$tmp_base"

        chown -R "$user_id:$group_id" "$tmp_base" >/dev/null 2>&1
        chmod -R 700 "$tmp_base" >/dev/null 2>&1
    fi

    local new_tmp=""
    new_tmp="$(mktemp --directory --tmpdir="$tmp_base")"
    local ret=$?

    if (( ret != 0 )) || [ ! -d "$new_tmp" ]; then
        __e "Failed to create temporary directory: mktemp - $ret"
        exit 1
    fi

    chown -R "$user_id:$group_id" "$new_tmp" >/dev/null 2>&1
    chmod -R 700 "$new_tmp" >/dev/null 2>&1

    echo "$new_tmp"
    return 0
}

# Remove a secure tmporary directory.
#
# TODO: secure file deletion (shred fallback of dd)
function __p_rm_secure_tmp() {
    local tmp="$1"
    local parent="$(dirname "$tmp")"

    rm -rf "$tmp" 2>/dev/null
    rmdir "$parent" 2>/dev/null

    # rmdir may fail; this is acceptable as other temporary directories
    # were in use (i.e., concurrent access)
    return 0
}
