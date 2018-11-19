#!/bin/bash

# p is a concise, opinionated interface over pass+jq
# See: https://github.com/cipherboy/p for more information

# p-specific environment variables:
#
#   P_CWD  -- current subdirectory in password vault
#   P_MODE -- mode to use: {local, user, ssh}
#       P_MODE_USER -- local user account to use
#       P_MODE_SSH  -- remote host to use
#   P_PASS -- path to pass (https://www.passwordstore.org/) binary
#   P_JQ   -- path to jq (https://stedolan.github.io/jq/) binary

# p-shared environment variables:
#
#   VERBOSE -- if set, p will execute in verbose mode.

function p() {
    # [ stage: introduction ] #

    # This function is organized into the following sections:
    #
    #   - introduction -- what you're currently reading; this describes the
    #                     layout of this script
    #   - variables    -- all variables scoped to this script
    #   - helpers      -- small helper functions
    #   - functions    -- larger functions that are used by commands
    #   - execs        -- wrappers around calling pass and jq as necessary
    #   - commands     -- p's commands
    #   - core         -- core script flow
    #
    # Each stage is marked by a marker akin to the ones above and below, with
    # "introduction" or "variables" replaced by the current stage name.

    # [ stage: variables ] #

    # Information referenced by several sub-commands; these deserve their own
    # local variables. Note that we use the syntax local var="$(exec)" even
    # though this clobbers the return code; we don't care about return codes
    # at this stage.
    local _p_version="0.1"
    local _p_pass_path="$P_PATH"
    local _p_pass_which="$(command -v pass)"
    local _p_pass_url="https://www.passwordstore.org/"
    local _p_pass_dir="$HOME/.password-store"
    local _p_jq_path="$P_JQ"
    local _p_jq_which="$(command -v jq)"
    local _p_jq_url="https://stedolan.github.io/jq/"
    local _p_verbose="${VERBOSE+x}"

    # These variables are used to control what functions are called; they use
    # the "_pa" prefix to differentiate themselves from the above variables.
    local _pa_ls="false"
    local _pa_help="false"

    # [ stage: helpers ] #

    # Helper functions. Note that verbose output is always redirected to
    # stderr.
    function __v() {
        if [ "$_p_verbose" == "x" ]; then
            echo "v:" "$@" 1>&2
        fi
    }
    function __e() {
        echo "$@" 1>&2
    }
    function __d() {
        __p_e "e:" "$@"
        exit 1
    }

    # [ stage: functions ] #

    # Check that our processed environment variables are mostly sane to handle
    # common errors. This includes making sure that our core dependencies of
    # `pass` and `jq` are installed. No effort is made to ensure that these
    # are _useful_ however.
    function __p_env_check() {
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

        if [ "x$_p_jq_path" == "x" ] && [ "x$_p_jq_which" == "x" ]; then
            __e "Cannot find \`jq\` executable! Please provide it in the"
            __e "\`P_JQ\` environment variable or install it via your"
            __e "system's package manager. For more information, see:"
            __e "    $_p_jq_url"

            exit 1
        elif [ "x$_p_jq_path" == "x" ]; then
            _p_jq_path="$_p_jq_which"
        fi

        if [ "x$PASSWORD_STORE_DIR" != "x" ]; then
            _p_pass_dir="$PASSWORD_STORE_DIR"
        fi

        return 0
    }

    # Print help information; this is the most complete documentation about
    # the p interface there is outside of reading the script.
    function __p_help() {
        if [ "$_pa_help" == "false" ]; then
            return
        fi

        echo "Usage: p cmd [args]"
        echo ""
        echo "p - version $_p_version"
        echo "https://github.com/cipherboy/p"
        echo ""
        echo "Available Commands:"
        exit 0
    }

    # [ stage: execs ] #

    # Execute the pass command based on the contents of
    function __pass() {
        return 0
    }


    # [ stage: commands ] #
    function __p_ls() {
        return 0
    }

    # [ stage: core ] #

    # Validate our environment is sane.
    __p_env_check

    # Print help as the last thing we do before exiting; this ensures that if
    # an argument error occurred during subcommand parsing, we can print help
    # information if necessary.
    __p_help
}

p $@
