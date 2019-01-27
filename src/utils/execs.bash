# Execute the pass command with the given arguments.
function __pass() {
    # Note that we need to handle PASSWORD_STORE_DIR here: since _p_pass_dir
    # is the canonical variable (storing first PASSWORD_STORE_DIR, then any
    # command line flags passed to `p`). Operate in a subshell, so any changes
    # to the environment are contained.

    (
        export PASSWORD_STORE_DIR="$_p_pass_dir"
        export GNUPGHOME="$_p_pass_gpg_dir"
        $_p_pass_path "$@"
    )
}

# Execute gpg with the given arguments. Fallback to gpg if gpg2 is not
# available.
function __gpg() {
    (
        export GNUPGHOME="$_p_pass_gpg_dir"
        if command -v gpg2  > /dev/null; then
            gpg2 "$@"
        else
            gpg "$@"
        fi
    )
}

# Execute the jq command with the given arguments.
function __jq() {
    $_p_jq_path "$@"
}
