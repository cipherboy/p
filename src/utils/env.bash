# Check that our processed environment variables are mostly sane to handle
# common errors. This includes making sure that our core dependencies of
# `pass` and `jq` are installed and setting script-local variables from
# environment variables. No effort is made to ensure that passed values
# are _useful_ however; that'd require state beyond the scope of this
# function.
function __p_env_check() {
    # Validate path to `pass` binary.
    if [ "x$_p_pass_path" == "x" ] && [ "x$_p_pass_which" == "x" ]; then
        __e "Cannot find \`pass\` executable! Please provide it in the"
        __e "\`P_PATH\` environment variable or install it via your"
        __e "system's package manager. For more information, see:"
        __e "    $_p_pass_url"

        exit 1
    elif [ "x$_p_pass_path" == "x" ]; then
        _p_pass_path="$_p_pass_which"
        __v "Using $_p_pass_which as path to \`pass\` binary."
    fi

    # Validate path to `jq` binary.
    if [ "x$_p_jq_path" == "x" ] && [ "x$_p_jq_which" == "x" ]; then
        __e "Cannot find \`jq\` executable! Please provide it in the"
        __e "\`P_JQ\` environment variable or install it via your"
        __e "system's package manager. For more information, see:"
        __e "    $_p_jq_url"

        exit 1
    elif [ "x$_p_jq_path" == "x" ]; then
        _p_jq_path="$_p_jq_which"
    fi

    # Process path to password store location
    if [ "x$PASSWORD_STORE_DIR" != "x" ]; then
        _p_pass_dir="$PASSWORD_STORE_DIR"
    fi

    # Process path to gnupg home location
    if [ "x$GNUPGHOME" != "x" ]; then
        _p_pass_gpg_dir="$GNUPGHOME"
    fi

    if [ "x$P_CWD" != "x" ]; then
        __v "Loading cwd from environment: \`$P_CWD\`"
        _p_cwd="$P_CWD"
    fi

    return 0
}
