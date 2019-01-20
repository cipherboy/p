# Execute the pass command with the given arguments.
function __pass() {
    # Note that we need to handle PASSWORD_STORE_DIR here: since _p_pass_dir
    # is the canonical variable (storing first PASSWORD_STORE_DIR, then any
    # command line flags passed to `p`), if it differs, we should preserve the
    # old PASSWORD_STORE_DIR value.

    if [ -z "${PASSWORD_STORE_DIR+x}" ]; then
        local old_value="$PASSWORD_STORE_DIR"
    fi

    export PASSWORD_STORE_DIR="$_p_pass_dir"
    $_p_pass_path "$@"

    if [ -z "${old_value+x}" ]; then
        export PASSWORD_STORE_DIR="$old_value"
    else
        unset PASSWORD_STORE_DIR
    fi
}

# Execute the jq command with the given arguments.
function __jq() {
    $_p_jq_path "$@"
}
