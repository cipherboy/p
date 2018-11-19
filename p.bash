#!/bin/bash

# p is a concise, opinionated interface over pass+jq
# See: https://github.com/cipherboy/p for more information

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
    #
    # The following variables are respected by the p command; p-specific
    # environment variables are only used by p, whereas p-shared environment
    # variables are used by p and other utilities (e.g., make, pass, etc.)
    #
    # p-specific environment variables:
    #
    #   P_CWD  -- current subdirectory in password vault
    #   P_MODE -- mode to use: {local, user, ssh}
    #       P_MODE_USER -- local user account to use
    #       P_MODE_SSH  -- remote host to use
    #   P_PASS -- path to pass (https://www.passwordstore.org/) binary
    #   P_JQ   -- path to jq (https://stedolan.github.io/jq/) binary
    #
    # p-shared environment variables:
    #
    #   VERBOSE -- if set, p will execute in verbose mode.
    #   PASSWORD_STORE_DIR -- path to
    #
    # Note that when P_MODE is not local (i.e., use pass in the local user
    # context), we pass all arguments given to p onto the remote context
    # and re-execute p in that context. This sub-context is run interactively
    # so that any commands given seem native and a chance to source the remote
    # $HOME/.bashrc is given (to update environment variables as necessary).

    # [ stage: variables ] #

    # Information referenced by several sub-commands; these deserve their own
    # local variables. Note that we use the syntax local var="$(exec)" even
    # though this clobbers the return code; we don't care about return codes
    # at this stage.
    local _p_version="0.1"
    local _p_verbose="${VERBOSE+x}"
    local _p_cwd="/"
    local _p_remaining=()

    # pass-related variables
    local _p_pass_path="$P_PATH"
    local _p_pass_which="$(command -v pass)"
    local _p_pass_url="https://www.passwordstore.org/"
    local _p_pass_dir="$HOME/.password-store"

    # jq-related variables
    local _p_jq_path="$P_JQ"
    local _p_jq_which="$(command -v jq)"
    local _p_jq_url="https://stedolan.github.io/jq/"

    # These variables are used to control what functions are called; they use
    # the "_pa" prefix to differentiate themselves from the above variables.
    local _pc_ls="false"
    local _pc_copy="false"
    local _pc_help="false"

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

        return 0
    }

    # Process command line arguments
    function __p_args() {
        local found_command="false"
        for arg in "$@"; do
            if [ "x$arg" == "xhelp" ] || [ "x$arg" == "x--help" ] ||
                    [ "x$arg" == "x-h" ]; then
                _pc_help="true"
                found_command="true"
            elif [ "x$arg" == "xls" ] || [ "x$arg" == "xl" ]; then
                _pc_ls="true"
                found_command="true"
            elif [ "x$arg" == "xcopy" ] || [ "x$arg" == "xc" ]; then
                _pc_copy="true"
                found_command="true"
            elif [ "x$arg" == "x--verbose" ]; then
                _p_verbose="x"
            else
                _p_remaining+=("$arg")
            fi
        done

        if [ "$found_command" == "false" ]; then
            _pc_help="true"
        fi
    }

    # [ stage: execs ] #

    # Execute the pass command based on the contents of
    function __pass() {
        $_p_pass_path "$@"
    }


    # [ stage: commands ] #
    function ___p_ls() {
        __v "Value of _pc_ls: $_pc_ls"
        if [ "$_pc_ls" == "false" ]; then
            return 0
        fi

        __pass ls "$@"
    }

    function ___p_copy() {
        __v "Value of _pc_copy: $_pc_copy"
        if [ "$_pc_copy" == "false" ]; then
            return 0
        fi

        __pass cp "$@"
    }

    # Print help information; this is the most complete documentation about
    # using the p interface there is outside of reading the script.
    function ___p_help() {
        __v "Value of _pc_help: $_pc_help"
        if [ "$_pc_help" == "false" ]; then
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

    # [ stage: core ] #

    # Validate our environment is sane.
    __p_env_check

    # Process command line arguments
    __p_args "$@"

    # Each command is expected to handle its own execution environment; that
    # is, __p_ls() is always called and is expected to check _pc_ls to ensure
    # whether or not it needs to run.
    ___p_ls "${_p_remaining[@]}"
    ___p_copy "${_p_remaining[@]}"

    # Print help as the last thing we do before exiting; this ensures that if
    # an argument error occurred during subcommand parsing, we can print help
    # information if necessary.
    ___p_help
}

p "$@"
