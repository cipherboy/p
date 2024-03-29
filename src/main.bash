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
    . utils/keys.bash
    . utils/locks.bash
    . utils/paths.bash
    . utils/print_json.bash
    . utils/remote.bash
    . utils/remote_args.bash
    . utils/rtypr.bash
    . utils/sharg.bash

    # [ stage: execs ] #
    . utils/execs.bash

    # [ stage: commands ] #
    . commands/cat.bash
    . commands/cd.bash
    . commands/clone.bash
    . commands/cp.bash
    . commands/create.bash
    . commands/decrypt.bash
    . commands/dirs.bash
    . commands/edit.bash
    . commands/encrypt.bash
    . commands/find.bash
    . commands/generate.bash
    . commands/git.bash
    . commands/gpg.bash
    . commands/groups.bash
    . commands/json.bash
    . commands/keys.bash
    . commands/locate.bash
    . commands/ls.bash
    . commands/mkdir.bash
    . commands/open.bash
    . commands/mv.bash
    . commands/rm.bash
    . commands/search.bash
    . commands/ssh.bash
    . commands/sync.bash
    . commands/through.bash

    # [ stage: core ] #

    # Validate our environment is sane.
    __p_env_check

    # Process a limited set of command line arguments, to check if we're
    # doing a remote execution.
    _p_remote_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    if __p_is_remote; then
        __p_handle_remote "$@"
        return $?
    fi

    # Finally, parse all other command line arguments.
    _p_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

    if (( ret == 0 )); then
        _p_dispatch_subparser
    fi
}

p "$@"
