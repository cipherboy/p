# Command for making a new directory, and optionally initializing it with a
# set of known GPG IDs.
function ___p_mkdir() {
    __v "Value of _pc_mkdir: $_pc_mkdir"
    if [ "$_pc_mkdir" == "false" ]; then
        return 0
    fi

    local m_path=""
    local m_recursive=""
    local m_help=""

    for arg in "$@"; do
        if [ "x$arg" == "x--recursive" ] || [ "x$arg" == "x-recursive" ] ||
                [ "x$arg" == "x-r" ] || [ "x$arg" == "x-p" ]; then
            m_recursive="--parents"
        elif [ "x$m_path" == "x" ]; then
            m_path="$arg"
            if [ "x$m_help" == "x" ]; then
                m_help="false"
            fi
        else
            m_help="true"
        fi
    done

    if [ "x$m_help" == "xtrue" ] || [ "x$m_help" == "x" ]; then
        echo "Usage: p mkdir [-r] <dir>"
        echo ""
        echo "<dir>: relative (to cwd) or absolute (if prefixed with a /)"
        echo "       path to create."
        echo "--recursive, -r: recursively make directory"
        echo ""
        echo "Note: mkdir will attempt to propagate .gpg-id from the last-seen"
        echo "directory with a .gpg-id. This ensures that all permission"
        echo "changes have explicit side effects."
        return 0
    fi

    if [ "x${m_path:0:1}" != "x/" ]; then
        # When creating a directory recursively, simplify
        m_path="$(__p_path_simplify "$p_cwd/$m_path")"
    fi

    __v "Creating directory $m_path"

    mkdir $m_recursive "$_p_pass_dir/$m_path"

    local gpg_id_path="$_p_pass_dir/.gpg-id"
    local m_path_recurse="$m_path"
    while [ 1 ]; do
        if [ -e "$_p_pass_dir/$m_path_recurse/.gpg-id" ]; then
            gpg_id_path="$_p_pass_dir/$m_path_recurse/.gpg-id"
            break
        fi

        m_path_recurse="$(__p_path_simplify "$m_path_recurse/../")"
        __v "New path: $m_path_recurse"
    done

    if [ ! -e "$gpg_id_path" ]; then
        __d "Error! Unable to find .gpg-id file anywhere; cannot propagate IDs"
    fi

    local m_path_recurse="$m_path"
    while [ 1 ]; do
        local target_path="$_p_pass_dir/$m_path_recurse/.gpg-id"
        if [ ! -e "$target_path" ]; then
            cp "$gpg_id_path" "$target_path"
        else
            break
        fi
        m_path_recurse="$(__p_path_simplify "$m_path_recurse/../")"
        __v "New path: $m_path_recurse"
    done
}
