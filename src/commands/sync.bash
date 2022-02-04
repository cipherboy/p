# Sane git syncing with branches.
function ___p_sync() {
    local branch="$1"
    local origin="$2"
    local remote="$3"
    local is_help="false"

    if [ "$1" == "--help" ] || [ "$1" == "-help" ] ||
            [ "$1" == "-h" ]; then
        is_help="true"
    fi

    if [ "$is_help" == "true" ]; then
        echo "Usage: p sync [branch=current] [origin=origin] [remote=master]"
        echo ""
        echo "If [branch] is the same as [remote], try to merge [branch] with"
        echo "[origin]/[remote]. Else, try to fetch and rebase the current branch"
        echo "off of [origin]/[remote]. Afterwards, a push is attempted on [remote]."
        return 0
    fi

    if [ -z "$branch" ]; then
        branch="$(git rev-parse --abbrev-ref HEAD)"
    fi

    if [ -z "$origin" ]; then
        origin="origin"
    fi

    if [ -z "$remote" ]; then
        remote="master"
    fi

    echo "$branch - $origin/$remote"

    __pass git fetch --all

    if [ "$branch" == "$remote" ]; then
        __pass git checkout "$branch"
        __pass git merge "$origin/$remote"
        __pass git push "$origin" "$remote"
    else
        __pass git checkout "$branch"
        __pass git rebase -i "$origin/$remote"
        __pass git checkout "$remote"
        __pass git rebase -i "$branch"
        __pass git push "$origin" "$remote"
        __pass git checkout "$branch"
    fi
}
