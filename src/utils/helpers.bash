# Helper functions. Note that verbose output is always redirected to
# stderr.
function __v() {
    if [ "$_p_verbose" == "x" ]; then
        echo "v:" "$@" 1>&2
    fi
}

function __e() {
    echo -e "$@" 1>&2
}

function __p_dir() {
    echo "$@"
}

function __d() {
    __e "e:" "$@"
    exit 1
}
