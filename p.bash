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
    local _pc_cat="false"
    local _pc_edit="false"
    local _pc_json="false"
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
        __e "e:" "$@"
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

        if [ "x$P_CWD" != "x" ]; then
            _p_cwd="$P_CWD"
        fi

        return 0
    }

    # Process command line arguments
    function __p_args() {
        local found_command="false"

        for count in $(seq 1 $#); do
            local arg="$1"
            shift

            if [ "x$arg" == "xhelp" ] || [ "x$arg" == "x--help" ] ||
                    [ "x$arg" == "x-h" ]; then
                _pc_help="true"
                found_command="true"
            elif [ "x$arg" == "xlist" ] || [ "x$arg" == "xls" ] ||
                    [ "x$arg" == "xl" ]; then
                _pc_ls="true"
                found_command="true"
            elif [ "x$arg" == "xla" ]; then
                _pc_ls="true"
                found_command="true"
                _p_remaining+=("--all")
            elif [ "x$arg" == "xld" ]; then
                _pc_ls="true"
                found_command="true"
                _p_remaining+=("--dir")
            elif [ "x$arg" == "xcopy" ] || [ "x$arg" == "xcp" ]; then
                _pc_copy="true"
                found_command="true"
            elif [ "x$arg" == "xshow" ] || [ "x$arg" == "xcat" ] ||
                    [ "x$arg" == "xc" ]; then
                _pc_cat="true"
                found_command="true"
            elif [ "x$arg" == "xedit" ] || [ "x$arg" == "xe" ]; then
                _pc_edit="true"
                found_command="true"
            elif [ "x$arg" == "xjson" ] || [ "x$arg" == "xj" ]; then
                _pc_json="true"
                found_command="true"
            elif [ "x$arg" == "xget" ] || [ "x$arg" == "xg" ] ||
                    [ "x$arg" == "xjg" ]; then
                _pc_json="true"
                found_command="true"
                _p_remaining+=("get")
            elif [ "x$arg" == "xset" ] || [ "x$arg" == "xs" ] ||
                    [ "x$arg" == "xjs" ]; then
                _pc_json="true"
                found_command="true"
                _p_remaining+=("set")
            elif [ "x$arg" == "x--verbose" ]; then
                _p_verbose="x"
            else
                echo "Unknown global option or argument: $arg"
                _pc_help="true"
                return 0
            fi

            if [ "x$found_command" == "xtrue" ]; then
                break
            fi
        done

        for arg in "$@"; do
            if [ "x$arg" == "x--verbose" ]; then
                _p_verbose="x"
            else
                _p_remaining+=("$arg")
            fi
        done
    }

    # Join paths for handling by `pass`. This handles the following cases:
    #
    #   - leading '/'s
    #   - `..` as a path segment
    #   - `.` as a path segment
    #
    # Note that we cannot use `[ -d ... ]`, `readlink`, or `abspath` as the
    # paths may not exist at this stage. Using python's os.path.abspath also
    # isn't an option since it'd allow us to escape above the password-store
    # directory and would require us to parse out the `pwd` prefix.
    function __p_join() {
        local concated_path=""
        for arg in "$@"; do
            if [ "x$concated_path" == "x" ]; then
                concated_path="$arg"
            else
                concated_path="$concated_path/$arg"
            fi
        done

        __p_path_simplify "$concated_path"
    }

    # Simplify a path, echoing the result. Note that the path cannot exceed
    # the passed depth:
    #
    #   ../../../ = /
    #   a/../../ = /
    #   a/b/../ = a/
    #
    # This is the internal version of the call that does most of the work;
    # __p_path_simplify(path) calls __p_path_simplify_internal until the
    # result is stable.
    function __p_path_simplify_internal() {
        local path="$1"
        __v "    starting_path: $path"

        shopt -s extglob

        # Replace occurrences of 'dir/../' with ''
        current_path=""
        next_path="$path"
        while [ "x$current_path" != "x$next_path" ]; do
            __v "    1:current_path: $current_path"
            __v "    1:next_path: $next_path"
            current_path="$next_path"
            next_path="${current_path/*([^\/])\/..\//}"
        done

        # Replace occurrences of ^../ (../ at the beginning) with /
        current_path=""
        while [ "x$current_path" != "x$next_path" ]; do
            __v "    2:current_path: $current_path"
            __v "    2:next_path: $next_path"
            current_path="$next_path"
            next_path="${current_path/#..\//\/}"
        done

        # Replace occurrences of '/./' with '/'
        current_path=""
        while [ "x$current_path" != "x$next_path" ]; do
            __v "    3:current_path: $current_path"
            __v "    3:next_path: $next_path"
            current_path="$next_path"
            next_path="${current_path//\/.\//\/}"
        done

        # Replace occurrences of '#./' with '/'
        current_path=""
        while [ "x$current_path" != "x$next_path" ]; do
            __v "    4:current_path: $current_path"
            __v "    4:next_path: $next_path"
            current_path="$next_path"
            next_path="${current_path/#.\//\/}"
        done

        # Replace occurrences of '%/.' with '/'
        current_path=""
        while [ "x$current_path" != "x$next_path" ]; do
            __v "    4:current_path: $current_path"
            __v "    4:next_path: $next_path"
            current_path="$next_path"
            next_path="${current_path/%\/./\/}"
        done


        # Replace occurrences of '//' with '/'
        current_path=""
        while [ "x$current_path" != "x$next_path" ]; do
            __v "    5:current_path: $current_path"
            __v "    5:next_path: $next_path"
            current_path="$next_path"
            next_path="${current_path//\/\//\/}"
        done

        echo "$current_path"
    }

    # Note that this is not suitable to call on true file system paths,
    # especially for destructive operations: the following construct "equals"
    # '/' or the root, but isn't necessarily so:
    #
    #       a/b/c/d/../../../../../
    #
    # Answer is given on stdout. stderr is meaningless and contains random
    # debug information in verbose mode.
    function __p_path_simplify() {
        local current_path=""
        local next_path="$1"

        while [ "x$current_path" != "x$next_path" ]; do
            __v "current_path: $current_path"
            __v "next_path: $next_path"
            current_path="$next_path"
            next_path="$(__p_path_simplify_internal "$current_path")"
        done

        echo "$next_path"
    }

    # Prints the output of jq as a "properly formatted" pass entry; in
    # particular, print the contents of the password prior to the JSON
    # structure. Note that the password is updated to match the JSON
    # structure. Meant to be used as part of a pipe chain.
    function __p_print_json() {
        # Note that this buffers until it has read all input up to this
        # point. This means that __p_print_json will stall if the input
        # hasn't finished.
        local stdin="$(cat -)"
        echo "$stdin" | jq -r -M '.password'
        echo "$stdin" | jq -r -M '.'
    }

    # [ stage: execs ] #

    # Execute the pass command with the given arguments
    function __pass() {
        $_p_pass_path "$@"
    }

    function __jq() {
        $_p_jq_path "$@"
    }


    # [ stage: commands ] #

    # ls with optional respect to $P_CWD
    #
    # Supports the -d and -a parameters from ls; -a shows .gpg-id and
    # .gpg suffix as well.
    function ___p_ls() {
        __v "Value of _pc_ls: $_pc_ls"
        if [ "$_pc_ls" == "false" ]; then
            return 0
        fi

        local ls_dir="false"
        local ls_all="false"
        local ls_targets=()
        local ls_target_count=0

        for arg in "$@"; do
            if [ "x$arg" == "x--all" ] || [ "x$arg" == "x-all" ] ||
                    [ "x$arg" == "x-a" ]; then
                ls_all="true"
            elif [ "x$arg" == "x--directory" ] || [ "x$arg" == "x--dir" ] ||
                    [ "x$arg" == "x-directory" ] || [ "x$arg" == "x-dir" ] ||
                    [ "x$arg" == "x-d" ]; then
                ls_dir="true"
            else
                local arg_path="$(__p_path_simplify "/$arg")"
                local arg_cwd_path="$(__p_path_simplify "$_p_cwd/$arg")"
                if [ -e "$_p_pass_dir/$arg_cwd_path" ]; then
                    ls_targets+=("$arg_cwd_path")
                elif [ -e "$_p_pass_dir/$arg_path" ]; then
                    ls_targets+=("$arg_path")
                else
                    if [ "x$arg_path" != "x$arg_cwd_path" ]; then
                        __d "Unknown argument, path not found, or not a" \
                            "directory: '$arg_path' and '$arg_cwd_path'." \
                            "If the path is an encrypted item, note that" \
                            " \`p\` differs from \`pass\` in that the " \
                            "\`ls\` command will not show encrypted secrets."
                    else
                        __d "Unknown argument, path not found, or not a" \
                            "directory: '$arg_path'. If the path is an" \
                            "encrypted item, note that \`p\` differs from" \
                            "\`pass\` in that the \`ls\` command will not" \
                            "show encrypted secrets."
                    fi
                fi
            fi
        done

        ls_target_count="${#ls_targets[@]}"

        # If we have no targets but P_CWD specified, act as if that is our
        # single argument.
        if [ "$ls_target_count" == "0" ] && [ "$_p_cwd" != "/" ]; then
            ls_targets+=("$_p_cwd")
            ls_target_count=1
        fi

        if [ "$ls_dir" == "false" ] && [ "$ls_all" == "false" ]; then
            if [ "$ls_target_count" == "0" ]; then
                __pass ls
            else
                # pass lacks support for showing multiple directories;
                # emulate this by passing each one individually.
                for path in "${ls_targets[@]}"; do
                    if [ "$path" == "/" ]; then
                        __pass ls
                        echo ""
                    else
                        __pass ls "$path"
                        echo ""
                    fi
                done
            fi
        elif [ "$ls_dir" == "false" ] && [ "$ls_all" == "true" ]; then
            # All mode is equivalent to a raw "tree" command, without
            # filtering the .gpg-id files and .gpg suffix. We also correctly
            # show the target directory in color. ;-)
            if [ "$ls_target_count" == "0" ]; then
                tree -I ".git" -a -C "$_p_pass_dir"
            else
                for path in "${ls_targets[@]}"; do
                    if [ "$path" == "/" ]; then
                        tree -I ".git" -a -C "$_p_pass_dir"
                    else
                        tree -I ".git" -a -C "$_p_pass_dir/$path"
                    fi
                done
            fi
        elif [ "$ls_dir" == "true" ] && [ "$ls_all" == "false" ]; then
            # When we're in dir mode, only show the directories and prefer
            # colors. `tree` does this best, so best to defer to it.
            pushd "$_p_pass_dir" >/dev/null
                if [ "$ls_target_count" == "0" ]; then
                    echo "Password Store"
                    tree -d -C -l --noreport "$_p_pass_dir" | tail -n +2
                else
                    for path in "${ls_targets[@]}"; do
                        if [ "$path" == "/" ]; then
                            echo "Password Store"
                            tree -d -C -l --noreport "$_p_pass_dir" | tail -n +2
                            echo ""
                        else
                            __dir "$path"
                            tree -d -C -l --noreport "$_p_pass_dir/$path" | tail -n +2
                            echo ""
                        fi
                    done
                fi
            popd >/dev/null
        else
            __d "Current mode ls_dir:$ls_dir,ls_all:$ls_all unsupported!"
        fi
    }

    # cat with optional respect to $P_CWD
    #
    # Supports formatting and optionally colorizing the result with jq.
    function ___p_cat() {
        __v "Value of _pc_cat: $_pc_cat"
        if [ "$_pc_cat" == "false" ]; then
            return 0
        fi

        local cat_raw="false"
        local cat_json_only="false"
        local cat_colorize="true"
        local cat_targets=()

        for arg in "$@"; do
            if [ "x$arg" == "x--raw" ] || [ "x$arg" == "x-raw" ] ||
                    [ "x$arg" == "-r" ]; then
                cat_raw="true"
            elif [ "x$arg" == "x--json-only" ] || [ "x$arg" == "x-json-only" ] ||
                    [ "x$arg" == "x--json" ] || [ "x$arg" == "x-json" ] ||
                    [ "x$arg" == "x-j" ]; then
                cat_json_only="true"
            elif [ "x$arg" == "x--no-color" ] || [ "x$arg" == "x-n-color" ] ||
                    [ "x$arg" == "-n" ]; then
                cat_colorize="false"
            else
                local arg_path="$(__p_path_simplify "/$arg")"
                local arg_cwd_path="$(__p_path_simplify "$_p_cwd/$arg")"
                if [ -e "$_p_pass_dir/$arg_cwd_path.gpg" ]; then
                    cat_targets+=("$arg_cwd_path")
                elif [ -e "$_p_pass_dir/$arg_path.gpg" ]; then
                    cat_targets+=("$arg_path")
                else
                    if [ "x$arg_path" != "x$arg_cwd_path" ]; then
                        __d "Unknown argument, path not found, or not a" \
                            "file: '$arg_path' and '$arg_cwd_path'." \
                            "If the path is a directory, note that \`p\` " \
                            "differs from \`pass\` in that the \`cat\`" \
                            "command will not show directories."
                    else
                        __d "Unknown argument, path not found, or not a" \
                            "file: '$arg_path'. If the path is a directory," \
                            " note that \`p\` differs from \`pass\` in that" \
                            "the \`cat\` command will not show directories."
                    fi
                fi
            fi
        done

        for target in "${cat_targets[@]}"; do
            if [ "$cat_raw" == "false" ]; then
                local content="$(__pass show "$target")"
                local first_line="$(echo "$content" | head -n 1)"
                local rest="$(echo "$content" | tail -n +2)"

                # Check if the remaining contents are json
                echo "$rest" | __jq . >/dev/null 2>/dev/null
                local is_json="$?"

                if [ "$cat_json_only" == "false" ]; then
                    echo "$first_line"
                fi
                if [ "$cat_colorize" == "true" ] && [ "$is_json" == "0" ]; then
                    echo "$rest" | __jq -C -S
                else
                    echo "$rest"
                fi
            else
                __pass show "$target"
            fi
        done
    }

    function ___p_copy() {
        __v "Value of _pc_copy: $_pc_copy"
        if [ "$_pc_copy" == "false" ]; then
            return 0
        fi

        __pass cp "$@"
    }

    # Passthrough function for pass edit. Currently ignores $_p_cwd.
    function ___p_edit() {
        __v "Value of _pc_edit: $_pc_edit"
        if [ "$_pc_edit" == "false" ]; then
            return 0
        fi

        __pass edit "$@"
    }

    # Function for reading and editing JSON structure of files. Since pass
    # has an unofficial format with the first line being the password, we
    # must be careful to modify the first line to match the vlaue of password
    # iff the password matches the present JSON value and we're updating it.
    # Otherwise, we'll print a warning about what we're supposed to do.
    #
    # Remote execution requirements: this command must be executed on the
    # remote host entirely.
    function ___p_json() {
        __v "Value of _pc_json: $_pc_json"
        if [ "$_pc_json" == "false" ]; then
            return 0
        fi

        j_command="$1"
        j_file="$2"
        j_key="$3"
        j_value="$4"

        if [ "x$j_command" == "xget" ] && (( $# == 3 )); then
            # Perform get operation on file / key
            _pc_cat="true" ___p_cat --json-only --no-color "$j_file" | jq -r ".$j_key"
        elif [ "x$j_command" == "xset" ] && (( $# == 4 )); then
            # Perform set operation on file / key = value
            if [ "x$j_key" == "xpassword" ]; then
                _pc_cat="true" ___p_cat --json-only --no-color "$j_file" | jq ".old_passwords=[.password]+.old_passwords|.password=\"$j_value\"" | __p_print_json | pass insert -m -f "$j_file"
            else
                _pc_cat="true" ___p_cat --json-only --no-color "$j_file" | jq ".$key=\"$j_value\"" | __p_print_json | pass insert -m -f "$j_file"
            fi
        else
            echo "Usage: p json <subcommand> <arguments>"
            echo ""
            echo "Subcommands:"
            echo "    get <file> <key> - read key from the file's JSON data"
            echo "    help - show this help text"
            echo "    set <file> <key> <value> - set the value of key in file"
            echo ""
            echo "Note:"
            echo "The underlying JSON is manipulated using \`jq\`. The filter"
            echo "is created of the form '.\$key=\"\$value\"'. Note that this"
            echo "filter is created in \`/dev/shm\` and passed to jq as a"
            echo "file."

            return 1
        fi
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
        echo ""
        echo "ls"
        echo "copy"
        echo "cat"
        echo "edit"
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
    ___p_cat "${_p_remaining[@]}"
    ___p_edit "${_p_remaining[@]}"
    ___p_json "${_p_remaining[@]}"

    # Print help as the last thing we do before exiting; this ensures that if
    # an argument error occurred during subcommand parsing, we can print help
    # information if necessary.
    ___p_help
}

p "$@"
