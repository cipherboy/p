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
    . utils/globals.bash

    # [ stage: helpers ] #
    . utils/helpers.bash
    . utils/colors.bash

    # [ stage: functions ] #
    . utils/args.bash
    . utils/env.bash
    . utils/genpass.bash
    . utils/gpg.bash
    . utils/paths.bash
    . utils/print_json.bash
    . utils/rtypr.bash

    # [ stage: execs ] #
    . utils/execs.bash

    # [ stage: commands ] #
    . commands/cat.bash
    . commands/cd.bash
    . commands/clone.bash
    . commands/cp.bash
    . commands/create.bash
    . commands/decrypt.bash
    . commands/edit.bash
    . commands/encrypt.bash
    . commands/find.bash
    . commands/generate.bash
    . commands/git.bash
    . commands/json.bash
    . commands/keys.bash
    . commands/locate.bash
    . commands/ls.bash
    . commands/mkdir.bash
    . commands/open.bash
    . commands/mv.bash
    . commands/rm.bash
    . commands/through.bash

    . commands/help.bash

    # [ stage: core ] #

    # Validate our environment is sane.
    __p_env_check

    # Process command line arguments
    __p_args "$@"

    # Each command is expected to handle its own execution environment; that
    # is, __p_ls() is always called and is expected to check _pc_ls to ensure
    # whether or not it needs to run.

    ___p_cat "${_p_remaining[@]}"
    ___p_cd "${_p_remaining[@]}"
    ___p_clone "${_p_remaining[@]}"
    ___p_cp "${_p_remaining[@]}"
    ___p_create "${_p_remaining[@]}"
    ___p_locate "${_p_remaining[@]}"
    ___p_decrypt "${_p_remaining[@]}"
    ___p_edit "${_p_remaining[@]}"
    ___p_encrypt "${_p_remaining[@]}"
    ___p_find "${_p_remaining[@]}"
    ___p_generate "${_p_remaining[@]}"
    ___p_git "${_p_remaining[@]}"
    ___p_json "${_p_remaining[@]}"
    ___p_keys "${_p_remaining[@]}"
    ___p_ls "${_p_remaining[@]}"
    ___p_mkdir "${_p_remaining[@]}"
    ___p_mv "${_p_remaining[@]}"
    ___p_open "${_p_remaining[@]}"
    ___p_rm "${_p_remaining[@]}"
    ___p_through "${_p_remaining[@]}"

    # Print help as the last thing we do before exiting; this ensures that if
    # an argument error occurred during subcommand parsing, we can print help
    # information if necessary.
    ___p_help
}

p "$@"
