# Command for making a new directory, and optionally initializing it with a
# set of known GPG IDs.
function ___p_mkdir() {
    local m_path=""
    local m_recursive=""
    local m_absolute="false"
    local m_help=""

    for arg in "$@"; do
        if [ "$arg" == "--recursive" ] || [ "$arg" == "-recursive" ] ||
                [ "$arg" == "-r" ] || [ "$arg" == "-p" ]; then
            m_recursive="--parents"
        elif [ "$arg" == "--absolute" ] || [ "$arg" == "-absolute" ] ||
                [ "$arg" == "-a" ]; then
            m_absolute="true"
        elif [ -z "$m_path" ]; then
            m_path="$arg"
            if [ -z "$m_help" ]; then
                m_help="false"
            fi
        else
            m_help="true"
        fi
    done

    if [ "$m_help" == "true" ] || [ -z "$m_help" ]; then
        echo "Usage: p mkdir [-r] <dir>"
        echo ""
        echo "<dir>: relative (to cwd) or absolute (if prefixed with a /)"
        echo "       path to create."
        echo ""
        echo "--recursive, -r: recursively make directory"
        echo "--absolute, -a: treat <dir> as relative to /, even if not"
        echo "                prefixed by /"
        echo ""
        echo "Note: mkdir will attempt to propagate .gpg-id from the last-seen"
        echo "directory with a .gpg-id. This ensures that all permission"
        echo "changes have explicit side effects."
        return 0
    fi

    if [ "${m_path:0:1}" != "/" ] && [ "$m_absolute" == "false" ]; then
        # When creating a directory recursively, simplify
        __v "Treating path as relative: \`$_p_cwd\` -> \`$m_path\`"
        m_path="$(__p_path_simplify "$_p_cwd/$m_path")"
    fi

    __v "Creating directory $m_path"

    mkdir $m_recursive "$_p_pass_dir/$m_path"

    local gpg_id_path="$_p_pass_dir/.gpg-id"
    local m_path_recurse="$m_path"
    while true; do
        if [ -e "$_p_pass_dir/$m_path_recurse/.gpg-id" ]; then
            gpg_id_path="$_p_pass_dir/$m_path_recurse/.gpg-id"
            break
        fi

        if [ "$m_path_recurse" == "/" ]; then
            # We've reached the root and can't find a .gpg-id, break.
            break
        fi

        m_path_recurse="$(__p_path_simplify "$m_path_recurse/../")"
        __v "New path: $m_path_recurse"
    done

    if [ ! -e "$gpg_id_path" ]; then
        __d "Error! Unable to find .gpg-id file anywhere; cannot propagate IDs"
    fi

    local m_path_recurse="$m_path"
    while true; do
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
