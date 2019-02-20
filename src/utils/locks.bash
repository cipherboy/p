function __p_lock() {
    local name="$1"
    local lock="$_p_pass_dir/$name.lock"

    if ! __p_is_file "$name"; then
        __e "Refusing to lock non-file"
        return 2
    fi

    if [ -e "$lock" ]; then
        return 1
    fi

    touch "$lock"
}

function __p_unlock() {
    local name="$1"
    local lock="$_p_pass_dir/$name.lock"

    if [ -e "$lock" ]; then
        rm "$lock"
    fi
}
