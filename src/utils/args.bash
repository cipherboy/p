function _p_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif [ "x${arg:0:21}" == "x--password-store-dir=" ] || [ "x${arg:0:20}" == "x-password-store-dir=" ]; then
            local __tmp_password_store_dir="${arg#*=}"

            if [ ! -d "$__tmp_password_store_dir" ]; then
                _handle_parse_error "password-store-dir" "$__tmp_password_store_dir"
            else
                password_store_dir="$__tmp_password_store_dir"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "password_store_dir=${password_store_dir}"
                fi

            fi
        elif (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--password-store-dir" ] || [ "x$arg" == "x-password-store-dir" ] || [ "x$arg" == "x-P" ]; then
            local __tmp_password_store_dir="$1"
            shift

            if [ ! -d "$__tmp_password_store_dir" ]; then
                _handle_parse_error "password-store-dir" "$__tmp_password_store_dir"
            else
                password_store_dir="$__tmp_password_store_dir"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "password_store_dir=${password_store_dir}"
                fi

            fi
        elif [ "x${arg:0:17}" == "x--gnupg-home-dir=" ] || [ "x${arg:0:16}" == "x-gnupg-home-dir=" ]; then
            local __tmp_gnupg_home_dir="${arg#*=}"

            if [ ! -d "$__tmp_gnupg_home_dir" ]; then
                _handle_parse_error "gnupg-home-dir" "$__tmp_gnupg_home_dir"
            else
                gnupg_home_dir="$__tmp_gnupg_home_dir"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "gnupg_home_dir=${gnupg_home_dir}"
                fi

            fi
        elif (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--gnupg-home-dir" ] || [ "x$arg" == "x-gnupg-home-dir" ] || [ "x$arg" == "x-G" ]; then
            local __tmp_gnupg_home_dir="$1"
            shift

            if [ ! -d "$__tmp_gnupg_home_dir" ]; then
                _handle_parse_error "gnupg-home-dir" "$__tmp_gnupg_home_dir"
            else
                gnupg_home_dir="$__tmp_gnupg_home_dir"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "gnupg_home_dir=${gnupg_home_dir}"
                fi

            fi
        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            local __tmp_cmd="$arg"

            if [ "x$__tmp_cmd" == "xcat" ] || [ "x$__tmp_cmd" == "xshow" ] || [ "x$__tmp_cmd" == "xc" ]; then
                cmd="cat"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "cmd=${cmd}"
                fi

            elif [ "x$__tmp_cmd" == "xcd" ]; then
                cmd="cd"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "cmd=${cmd}"
                fi

            elif [ "x$__tmp_cmd" == "xclone" ]; then
                cmd="clone"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "cmd=${cmd}"
                fi

            elif [ "x$__tmp_cmd" == "xcp" ] || [ "x$__tmp_cmd" == "xcopy" ]; then
                cmd="cp"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "cmd=${cmd}"
                fi

            elif [ "x$__tmp_cmd" == "xcreate" ]; then
                cmd="create"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "cmd=${cmd}"
                fi

            elif [ "x$__tmp_cmd" == "xdecrypt" ]; then
                cmd="decrypt"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "cmd=${cmd}"
                fi

            elif [ "x$__tmp_cmd" == "xdirs" ] || [ "x$__tmp_cmd" == "xdir" ]; then
                cmd="dirs"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "cmd=${cmd}"
                fi

            elif [ "x$__tmp_cmd" == "xedit" ] || [ "x$__tmp_cmd" == "xe" ]; then
                cmd="edit"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "cmd=${cmd}"
                fi

            elif [ "x$__tmp_cmd" == "xencrypt" ]; then
                cmd="encrypt"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "cmd=${cmd}"
                fi

            elif [ "x$__tmp_cmd" == "xfind" ]; then
                cmd="find"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "cmd=${cmd}"
                fi

            elif [ "x$__tmp_cmd" == "xgenerate" ] || [ "x$__tmp_cmd" == "xgen" ]; then
                cmd="generate"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "cmd=${cmd}"
                fi

            elif [ "x$__tmp_cmd" == "xgit" ] || [ "x$__tmp_cmd" == "xgt" ]; then
                cmd="git"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "cmd=${cmd}"
                fi

            elif [ "x$__tmp_cmd" == "xgpg" ]; then
                cmd="gpg"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "cmd=${cmd}"
                fi

            elif [ "x$__tmp_cmd" == "xgroups" ] || [ "x$__tmp_cmd" == "xgroup" ]; then
                cmd="groups"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "cmd=${cmd}"
                fi

            elif [ "x$__tmp_cmd" == "xjson" ] || [ "x$__tmp_cmd" == "xj" ]; then
                cmd="json"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "cmd=${cmd}"
                fi

            elif [ "x$__tmp_cmd" == "xkeys" ] || [ "x$__tmp_cmd" == "xkey" ]; then
                cmd="keys"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "cmd=${cmd}"
                fi

            elif [ "x$__tmp_cmd" == "xlocate" ] || [ "x$__tmp_cmd" == "xlt" ]; then
                cmd="locate"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "cmd=${cmd}"
                fi

            elif [ "x$__tmp_cmd" == "xls" ] || [ "x$__tmp_cmd" == "xlist" ]; then
                cmd="ls"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "cmd=${cmd}"
                fi

            elif [ "x$__tmp_cmd" == "xmkdir" ] || [ "x$__tmp_cmd" == "xm" ]; then
                cmd="mkdir"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "cmd=${cmd}"
                fi

            elif [ "x$__tmp_cmd" == "xmv" ] || [ "x$__tmp_cmd" == "xmove" ]; then
                cmd="mv"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "cmd=${cmd}"
                fi

            elif [ "x$__tmp_cmd" == "xopen" ]; then
                cmd="open"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "cmd=${cmd}"
                fi

            elif [ "x$__tmp_cmd" == "xpass" ] || [ "x$__tmp_cmd" == "xthrough" ] || [ "x$__tmp_cmd" == "xthru" ] || [ "x$__tmp_cmd" == "xt" ]; then
                cmd="pass"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "cmd=${cmd}"
                fi

            elif [ "x$__tmp_cmd" == "xrm" ] || [ "x$__tmp_cmd" == "xremove" ]; then
                cmd="rm"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "cmd=${cmd}"
                fi

            elif [ "x$__tmp_cmd" == "xsearch" ] || [ "x$__tmp_cmd" == "xgrep" ]; then
                cmd="search"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "cmd=${cmd}"
                fi

            elif [ "x$__tmp_cmd" == "xsync" ]; then
                cmd="sync"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "cmd=${cmd}"
                fi

            else
                _handle_parse_error "cmd" "$__tmp_cmd"
            fi
        else
            cmd_args+=("$arg")
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "cmd_args=${cmd_args[@]} | len=${#cmd_args[@]}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        _p_print_help
        return 1
    fi
    return 0
}
function _p_print_help() {
    cat - << _p_print_help_EOF
Usage: p [options] <cmd> [vars.cmd_args...]
a concise, opinionated interface over pass

Arguments:
  cmd: p command to run
    Basic navigation:
      - cd: change directories
      - cp: copy the contents of one file to another location
      - ls: list files and directories
      - mkdir: make a new directory
      - mv: move a file to another location
      - rm: remove the specified path from the password store

    Managing passwords:
      - cat: show the contents of a password entry
      - edit: edit the contents of a file
      - generate: generate a new password
      - json: manipulate a JSON-encoded password file

    Search commands:
      - find: list all files in the password store
      - locate: locate files and directories matching a pattern
      - search: search the contents of files for a match

    Setup:
      - clone: create a password store from a git repository
      - create: create a password store from scratch
      - dirs: manage keys associated with directories
      - gpg: manage keys in GnuPG's database
      - groups: manage groups of keys used to encrypt passwords
      - keys: manage keys used to encrypt passwords

    Storing files:
      - decrypt: extract (decrypt) a file in the password store
      - encrypt: store a file into the password store
      - open: run a command to view a file in the password store

    Other commands:
      - git: run git commands in the password store
      - pass: pass a command through to pass (for accessing extensions)
      - sync: sync a local branch with a remote one

Options:
  --help, -h: Print this help text.
  --password-store-dir, -P <dir>: path to the password storage directory
  --gnupg-home-dir, -G <dir>: path to the GnuPG home directory
_p_print_help_EOF
}
function _p_dispatch_subparser() {
    if [ "x$cmd" == "xcat" ]; then
        ___p_cat "${cmd_args[@]}"
    elif [ "x$cmd" == "xcd" ]; then
        ___p_cd "${cmd_args[@]}"
    elif [ "x$cmd" == "xclone" ]; then
        ___p_clone "${cmd_args[@]}"
    elif [ "x$cmd" == "xcp" ]; then
        ___p_cp "${cmd_args[@]}"
    elif [ "x$cmd" == "xcreate" ]; then
        ___p_create "${cmd_args[@]}"
    elif [ "x$cmd" == "xdecrypt" ]; then
        ___p_decrypt "${cmd_args[@]}"
    elif [ "x$cmd" == "xdirs" ]; then
        ___p_dirs "${cmd_args[@]}"
    elif [ "x$cmd" == "xedit" ]; then
        ___p_edit "${cmd_args[@]}"
    elif [ "x$cmd" == "xencrypt" ]; then
        ___p_encrypt "${cmd_args[@]}"
    elif [ "x$cmd" == "xfind" ]; then
        ___p_find "${cmd_args[@]}"
    elif [ "x$cmd" == "xgenerate" ]; then
        ___p_generate "${cmd_args[@]}"
    elif [ "x$cmd" == "xgit" ]; then
        ___p_git "${cmd_args[@]}"
    elif [ "x$cmd" == "xgpg" ]; then
        ___p_gpg "${cmd_args[@]}"
    elif [ "x$cmd" == "xgroups" ]; then
        ___p_groups "${cmd_args[@]}"
    elif [ "x$cmd" == "xjson" ]; then
        ___p_json "${cmd_args[@]}"
    elif [ "x$cmd" == "xkeys" ]; then
        ___p_keys "${cmd_args[@]}"
    elif [ "x$cmd" == "xlocate" ]; then
        ___p_locate "${cmd_args[@]}"
    elif [ "x$cmd" == "xls" ]; then
        ___p_ls "${cmd_args[@]}"
    elif [ "x$cmd" == "xmkdir" ]; then
        ___p_mkdir "${cmd_args[@]}"
    elif [ "x$cmd" == "xmv" ]; then
        ___p_mv "${cmd_args[@]}"
    elif [ "x$cmd" == "xopen" ]; then
        ___p_open "${cmd_args[@]}"
    elif [ "x$cmd" == "xpass" ]; then
        ___p_through "${cmd_args[@]}"
    elif [ "x$cmd" == "xrm" ]; then
        ___p_rm "${cmd_args[@]}"
    elif [ "x$cmd" == "xsearch" ]; then
        ___p_search "${cmd_args[@]}"
    elif [ "x$cmd" == "xsync" ]; then
        ___p_sync "${cmd_args[@]}"
    elif [ ! -z "$cmd" ]; then
        _handle_dispatch_error "$cmd"
    else
        _p_print_help
    fi
}
function ___p_clone_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            uri="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "uri=${uri}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_clone_print_help
        return 1
    fi
    return 0
}
function ___p_clone_print_help() {
    cat - << ___p_clone_print_help_EOF
Usage: p clone [options] <uri>
create a password store from a git repository

Arguments:
  uri: URI that the git repository resides at

Options:
  --help, -h: Print this help text.
___p_clone_print_help_EOF
}
function ___p_create_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--without-git" ] || [ "x$arg" == "x-without-git" ] || [ "x$arg" == "x-n" ]; then
            without_git="false"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "without_git=${without_git}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            gpg_id="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "gpg_id=${gpg_id}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_create_print_help
        return 1
    fi
    return 0
}
function ___p_create_print_help() {
    cat - << ___p_create_print_help_EOF
Usage: p create [options] <gpg_id>
create a password store from scratch

Arguments:
  gpg_id: GPG Key ID to initialize password store with

Options:
  --help, -h: Print this help text.
  --without-git, -n: don't create the password store with git
___p_create_print_help_EOF
}
function ___p_keys_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            local __tmp_key_cmd="$arg"

            if [ "x$__tmp_key_cmd" == "xdelete" ]; then
                key_cmd="delete"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "key_cmd=${key_cmd}"
                fi

            elif [ "x$__tmp_key_cmd" == "xexport" ]; then
                key_cmd="export"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "key_cmd=${key_cmd}"
                fi

            elif [ "x$__tmp_key_cmd" == "ximport" ]; then
                key_cmd="import"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "key_cmd=${key_cmd}"
                fi

            elif [ "x$__tmp_key_cmd" == "xinit" ]; then
                key_cmd="init"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "key_cmd=${key_cmd}"
                fi

            elif [ "x$__tmp_key_cmd" == "xlist" ]; then
                key_cmd="list"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "key_cmd=${key_cmd}"
                fi

            elif [ "x$__tmp_key_cmd" == "xregen" ]; then
                key_cmd="regen"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "key_cmd=${key_cmd}"
                fi

            elif [ "x$__tmp_key_cmd" == "xrename" ]; then
                key_cmd="rename"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "key_cmd=${key_cmd}"
                fi

            elif [ "x$__tmp_key_cmd" == "xupdate" ]; then
                key_cmd="update"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "key_cmd=${key_cmd}"
                fi

            else
                _handle_parse_error "key_cmd" "$__tmp_key_cmd"
            fi
        else
            key_cmd_args+=("$arg")
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "key_cmd_args=${key_cmd_args[@]} | len=${#key_cmd_args[@]}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_keys_print_help
        return 1
    fi
    return 0
}
function ___p_keys_print_help() {
    cat - << ___p_keys_print_help_EOF
Usage: p keys [options] <key_cmd> [vars.key_cmd_args...]
manage keys used to encrypt passwords

Arguments:
  key_cmd: key management action
    - init: initialize the key manager
    - import: import a key from gpg's database
    - export: export a key into GnuPG's database and sign it
    - list: list all keys in the key manager
    - regen: recreate all .gpg-id files and re-encrypt passwords
    - delete: delete a key from the key manager
    - rename: change the nickname of a key
    - update: update a key in the database

Options:
  --help, -h: Print this help text.
___p_keys_print_help_EOF
}
function ___p_keys_dispatch_subparser() {
    if [ "x$key_cmd" == "xdelete" ]; then
        ___p_key_delete "${key_cmd_args[@]}"
    elif [ "x$key_cmd" == "xexport" ]; then
        ___p_key_export "${key_cmd_args[@]}"
    elif [ "x$key_cmd" == "ximport" ]; then
        ___p_key_import "${key_cmd_args[@]}"
    elif [ "x$key_cmd" == "xinit" ]; then
        ___p_key_init "${key_cmd_args[@]}"
    elif [ "x$key_cmd" == "xlist" ]; then
        ___p_keys_list "${key_cmd_args[@]}"
    elif [ "x$key_cmd" == "xregen" ]; then
        ___p_keys_regen "${key_cmd_args[@]}"
    elif [ "x$key_cmd" == "xrename" ]; then
        ___p_key_rename "${key_cmd_args[@]}"
    elif [ "x$key_cmd" == "xupdate" ]; then
        ___p_key_update "${key_cmd_args[@]}"
    elif [ ! -z "$key_cmd" ]; then
        _handle_dispatch_error "$key_cmd"
    else
        ___p_keys_print_help
    fi
}
function ___p_key_init_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            key_id="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "key_id=${key_id}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_key_init_print_help
        return 1
    fi
    return 0
}
function ___p_key_init_print_help() {
    cat - << ___p_key_init_print_help_EOF
Usage: p keys init [options] <key_id>
initialize the key manager

Arguments:
  key_id: default key to use for key management

Options:
  --help, -h: Print this help text.
___p_key_init_print_help_EOF
}
function ___p_key_import_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 2 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            key_nickname="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "key_nickname=${key_nickname}"
            fi

        elif (( $_parse_args_positional_index == 1 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            key_id="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "key_id=${key_id}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_key_import_print_help
        return 1
    fi
    return 0
}
function ___p_key_import_print_help() {
    cat - << ___p_key_import_print_help_EOF
Usage: p keys import [options] <key_nickname> <key_id>
import a key from gpg's database

Arguments:
  key_nickname: nickname of the key to import
  key_id: GPG Key ID to import

Options:
  --help, -h: Print this help text.
___p_key_import_print_help_EOF
}
function ___p_key_export_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            key_nickname="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "key_nickname=${key_nickname}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_key_export_print_help
        return 1
    fi
    return 0
}
function ___p_key_export_print_help() {
    cat - << ___p_key_export_print_help_EOF
Usage: p keys export [options] <key_nickname>
export a key into GnuPG's database and sign it

Arguments:
  key_nickname: nickname of the key to export

Options:
  --help, -h: Print this help text.
___p_key_export_print_help_EOF
}
function ___p_keys_list_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"


        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_keys_list_print_help
        return 1
    fi
    return 0
}
function ___p_keys_list_print_help() {
    cat - << ___p_keys_list_print_help_EOF
Usage: p keys list
list all keys in the key manager

Options:
  --help, -h: Print this help text.
___p_keys_list_print_help_EOF
}
function ___p_keys_regen_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"


        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_keys_regen_print_help
        return 1
    fi
    return 0
}
function ___p_keys_regen_print_help() {
    cat - << ___p_keys_regen_print_help_EOF
Usage: p keys regen
recreate all .gpg-id files and re-encrypt passwords

Options:
  --help, -h: Print this help text.
___p_keys_regen_print_help_EOF
}
function ___p_key_delete_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            key_nickname="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "key_nickname=${key_nickname}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_key_delete_print_help
        return 1
    fi
    return 0
}
function ___p_key_delete_print_help() {
    cat - << ___p_key_delete_print_help_EOF
Usage: p keys delete [options] <key_nickname>
delete a key from the key manager

Arguments:
  key_nickname: nickname of the key to delete

Options:
  --help, -h: Print this help text.
___p_key_delete_print_help_EOF
}
function ___p_key_rename_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 2 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            key_old="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "key_old=${key_old}"
            fi

        elif (( $_parse_args_positional_index == 1 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            key_new="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "key_new=${key_new}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_key_rename_print_help
        return 1
    fi
    return 0
}
function ___p_key_rename_print_help() {
    cat - << ___p_key_rename_print_help_EOF
Usage: p keys rename [options] <key_old> <key_new>
change the nickname of a key

Arguments:
  key_old: nickname of the key to rename
  key_new: new name for the key

Options:
  --help, -h: Print this help text.
___p_key_rename_print_help_EOF
}
function ___p_key_update_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            key_nickname="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "key_nickname=${key_nickname}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_key_update_print_help
        return 1
    fi
    return 0
}
function ___p_key_update_print_help() {
    cat - << ___p_key_update_print_help_EOF
Usage: p keys update [options] <key_nickname>
update a key in the database

Arguments:
  key_nickname: nickname of the key to update

Options:
  --help, -h: Print this help text.
___p_key_update_print_help_EOF
}
function ___p_groups_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            local __tmp_group_cmd="$arg"

            if [ "x$__tmp_group_cmd" == "xadd" ]; then
                group_cmd="add"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "group_cmd=${group_cmd}"
                fi

            elif [ "x$__tmp_group_cmd" == "xcreate" ]; then
                group_cmd="create"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "group_cmd=${group_cmd}"
                fi

            elif [ "x$__tmp_group_cmd" == "xdelete" ]; then
                group_cmd="delete"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "group_cmd=${group_cmd}"
                fi

            elif [ "x$__tmp_group_cmd" == "xlist" ]; then
                group_cmd="list"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "group_cmd=${group_cmd}"
                fi

            elif [ "x$__tmp_group_cmd" == "xremove" ]; then
                group_cmd="remove"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "group_cmd=${group_cmd}"
                fi

            else
                _handle_parse_error "group_cmd" "$__tmp_group_cmd"
            fi
        else
            group_cmd_args+=("$arg")
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "group_cmd_args=${group_cmd_args[@]} | len=${#group_cmd_args[@]}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_groups_print_help
        return 1
    fi
    return 0
}
function ___p_groups_print_help() {
    cat - << ___p_groups_print_help_EOF
Usage: p groups [options] <group_cmd> [vars.group_cmd_args...]
manage groups of keys used to encrypt passwords

Arguments:
  group_cmd: group management action
    - create: create a new group
    - add: add keys to a group
    - remove: remove keys from a group
    - delete: delete a group
    - list: list all groups

Options:
  --help, -h: Print this help text.
___p_groups_print_help_EOF
}
function ___p_groups_dispatch_subparser() {
    if [ "x$group_cmd" == "xadd" ]; then
        ___p_group_add "${group_cmd_args[@]}"
    elif [ "x$group_cmd" == "xcreate" ]; then
        ___p_group_create "${group_cmd_args[@]}"
    elif [ "x$group_cmd" == "xdelete" ]; then
        ___p_group_delete "${group_cmd_args[@]}"
    elif [ "x$group_cmd" == "xlist" ]; then
        ___p_group_list "${group_cmd_args[@]}"
    elif [ "x$group_cmd" == "xremove" ]; then
        ___p_group_remove "${group_cmd_args[@]}"
    elif [ ! -z "$group_cmd" ]; then
        _handle_dispatch_error "$group_cmd"
    else
        ___p_groups_print_help
    fi
}
function ___p_group_create_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 2 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            group_name="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "group_name=${group_name}"
            fi

        elif (( $_parse_args_positional_index == 1 )); then
            group_keys+=("$arg")
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "group_keys=${group_keys[@]} | len=${#group_keys[@]}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_group_create_print_help
        return 1
    fi
    return 0
}
function ___p_group_create_print_help() {
    cat - << ___p_group_create_print_help_EOF
Usage: p groups create [options] <group_name> <group_keys...>
create a new group

Arguments:
  group_name: nickname of the group to create
  group_keys: nickname of the keys to add to the group

Options:
  --help, -h: Print this help text.
___p_group_create_print_help_EOF
}
function ___p_group_add_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 2 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            group_name="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "group_name=${group_name}"
            fi

        elif (( $_parse_args_positional_index == 1 )); then
            group_keys+=("$arg")
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "group_keys=${group_keys[@]} | len=${#group_keys[@]}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_group_add_print_help
        return 1
    fi
    return 0
}
function ___p_group_add_print_help() {
    cat - << ___p_group_add_print_help_EOF
Usage: p groups add [options] <group_name> <group_keys...>
add keys to a group

Arguments:
  group_name: group to extend with new keys
  group_keys: nickname of the keys to add to the group

Options:
  --help, -h: Print this help text.
___p_group_add_print_help_EOF
}
function ___p_group_remove_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 2 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            group_name="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "group_name=${group_name}"
            fi

        elif (( $_parse_args_positional_index == 1 )); then
            group_keys+=("$arg")
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "group_keys=${group_keys[@]} | len=${#group_keys[@]}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_group_remove_print_help
        return 1
    fi
    return 0
}
function ___p_group_remove_print_help() {
    cat - << ___p_group_remove_print_help_EOF
Usage: p groups remove [options] <group_name> <group_keys...>
remove keys from a group

Arguments:
  group_name: group to remove keys from
  group_keys: nickname of the keys to remove from the group

Options:
  --help, -h: Print this help text.
___p_group_remove_print_help_EOF
}
function ___p_group_delete_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            group_name="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "group_name=${group_name}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_group_delete_print_help
        return 1
    fi
    return 0
}
function ___p_group_delete_print_help() {
    cat - << ___p_group_delete_print_help_EOF
Usage: p groups delete [options] <group_name>
delete a group

Arguments:
  group_name: group to extend with new keys

Options:
  --help, -h: Print this help text.
___p_group_delete_print_help_EOF
}
function ___p_group_list_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"


        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_group_list_print_help
        return 1
    fi
    return 0
}
function ___p_group_list_print_help() {
    cat - << ___p_group_list_print_help_EOF
Usage: p groups list
list all groups

Options:
  --help, -h: Print this help text.
___p_group_list_print_help_EOF
}
function ___p_dirs_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            local __tmp_dir_cmd="$arg"

            if [ "x$__tmp_dir_cmd" == "xadd" ]; then
                dir_cmd="add"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "dir_cmd=${dir_cmd}"
                fi

            elif [ "x$__tmp_dir_cmd" == "xcreate" ]; then
                dir_cmd="create"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "dir_cmd=${dir_cmd}"
                fi

            elif [ "x$__tmp_dir_cmd" == "xdelete" ]; then
                dir_cmd="delete"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "dir_cmd=${dir_cmd}"
                fi

            elif [ "x$__tmp_dir_cmd" == "xlist" ]; then
                dir_cmd="list"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "dir_cmd=${dir_cmd}"
                fi

            elif [ "x$__tmp_dir_cmd" == "xremove" ]; then
                dir_cmd="remove"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "dir_cmd=${dir_cmd}"
                fi

            else
                _handle_parse_error "dir_cmd" "$__tmp_dir_cmd"
            fi
        else
            dir_cmd_args+=("$arg")
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "dir_cmd_args=${dir_cmd_args[@]} | len=${#dir_cmd_args[@]}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_dirs_print_help
        return 1
    fi
    return 0
}
function ___p_dirs_print_help() {
    cat - << ___p_dirs_print_help_EOF
Usage: p dirs [options] <dir_cmd> [vars.dir_cmd_args...]
manage keys associated with directories

Arguments:
  dir_cmd: directory management action
    - create: track a new directory
    - add: add keys to a directory
    - remove: remove keys from a directory
    - delete: delete keys for a directory
    - list: list all directories

Options:
  --help, -h: Print this help text.
___p_dirs_print_help_EOF
}
function ___p_dirs_dispatch_subparser() {
    if [ "x$dir_cmd" == "xadd" ]; then
        ___p_dir_add "${dir_cmd_args[@]}"
    elif [ "x$dir_cmd" == "xcreate" ]; then
        ___p_dir_create "${dir_cmd_args[@]}"
    elif [ "x$dir_cmd" == "xdelete" ]; then
        ___p_dir_delete "${dir_cmd_args[@]}"
    elif [ "x$dir_cmd" == "xlist" ]; then
        ___p_dir_list "${dir_cmd_args[@]}"
    elif [ "x$dir_cmd" == "xremove" ]; then
        ___p_dir_remove "${dir_cmd_args[@]}"
    elif [ ! -z "$dir_cmd" ]; then
        _handle_dispatch_error "$dir_cmd"
    else
        ___p_dirs_print_help
    fi
}
function ___p_dir_create_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 2 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            dir_path="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "dir_path=${dir_path}"
            fi

        elif (( $_parse_args_positional_index == 1 )); then
            dir_keys+=("$arg")
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "dir_keys=${dir_keys[@]} | len=${#dir_keys[@]}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_dir_create_print_help
        return 1
    fi
    return 0
}
function ___p_dir_create_print_help() {
    cat - << ___p_dir_create_print_help_EOF
Usage: p dirs create [options] <dir_path> <dir_keys...>
track a new directory

Arguments:
  dir_path: path of the directory to manage
  dir_keys: nickname of the keys or groups to encrypt the directory with

Options:
  --help, -h: Print this help text.
___p_dir_create_print_help_EOF
}
function ___p_dir_add_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 2 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            dir_path="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "dir_path=${dir_path}"
            fi

        elif (( $_parse_args_positional_index == 1 )); then
            dir_keys+=("$arg")
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "dir_keys=${dir_keys[@]} | len=${#dir_keys[@]}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_dir_add_print_help
        return 1
    fi
    return 0
}
function ___p_dir_add_print_help() {
    cat - << ___p_dir_add_print_help_EOF
Usage: p dirs add [options] <dir_path> <dir_keys...>
add keys to a directory

Arguments:
  dir_path: directory to extend with new keys
  dir_keys: nickname of the keys to add to the directory

Options:
  --help, -h: Print this help text.
___p_dir_add_print_help_EOF
}
function ___p_dir_remove_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 2 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            dir_path="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "dir_path=${dir_path}"
            fi

        elif (( $_parse_args_positional_index == 1 )); then
            dir_keys+=("$arg")
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "dir_keys=${dir_keys[@]} | len=${#dir_keys[@]}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_dir_remove_print_help
        return 1
    fi
    return 0
}
function ___p_dir_remove_print_help() {
    cat - << ___p_dir_remove_print_help_EOF
Usage: p dirs remove [options] <dir_path> <dir_keys...>
remove keys from a directory

Arguments:
  dir_path: directory to remove keys from
  dir_keys: nickname of the keys to remove from the directory

Options:
  --help, -h: Print this help text.
___p_dir_remove_print_help_EOF
}
function ___p_dir_delete_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            dir_path="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "dir_path=${dir_path}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_dir_delete_print_help
        return 1
    fi
    return 0
}
function ___p_dir_delete_print_help() {
    cat - << ___p_dir_delete_print_help_EOF
Usage: p dirs delete [options] <dir_path>
delete keys for a directory

Arguments:
  dir_path: directory to quit tracking keys for

Options:
  --help, -h: Print this help text.
___p_dir_delete_print_help_EOF
}
function ___p_dir_list_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"


        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_dir_list_print_help
        return 1
    fi
    return 0
}
function ___p_dir_list_print_help() {
    cat - << ___p_dir_list_print_help_EOF
Usage: p dirs list
list all directories

Options:
  --help, -h: Print this help text.
___p_dir_list_print_help_EOF
}
function ___p_gpg_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            local __tmp_gpg_cmd="$arg"

            if [ "x$__tmp_gpg_cmd" == "xexport" ]; then
                gpg_cmd="export"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "gpg_cmd=${gpg_cmd}"
                fi

            elif [ "x$__tmp_gpg_cmd" == "xgenerate" ]; then
                gpg_cmd="generate"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "gpg_cmd=${gpg_cmd}"
                fi

            elif [ "x$__tmp_gpg_cmd" == "ximport" ]; then
                gpg_cmd="import"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "gpg_cmd=${gpg_cmd}"
                fi

            elif [ "x$__tmp_gpg_cmd" == "xlist" ]; then
                gpg_cmd="list"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "gpg_cmd=${gpg_cmd}"
                fi

            elif [ "x$__tmp_gpg_cmd" == "xpassword" ]; then
                gpg_cmd="password"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "gpg_cmd=${gpg_cmd}"
                fi

            elif [ "x$__tmp_gpg_cmd" == "xtrust" ]; then
                gpg_cmd="trust"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "gpg_cmd=${gpg_cmd}"
                fi

            else
                _handle_parse_error "gpg_cmd" "$__tmp_gpg_cmd"
            fi
        else
            gpg_cmd_args+=("$arg")
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "gpg_cmd_args=${gpg_cmd_args[@]} | len=${#gpg_cmd_args[@]}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_gpg_print_help
        return 1
    fi
    return 0
}
function ___p_gpg_print_help() {
    cat - << ___p_gpg_print_help_EOF
Usage: p gpg [options] <gpg_cmd> [vars.gpg_cmd_args...]
manage keys in GnuPG's database

Arguments:
  gpg_cmd: gpg management action
    - generate: generae a new GPG key
    - import: import a GPG key from a file
    - export: export a GPG key to a file
    - list: list all keys tracked by GPG
    - password: change the password on a key
    - trust: trust and sign the specified GPG key

Options:
  --help, -h: Print this help text.
___p_gpg_print_help_EOF
}
function ___p_gpg_dispatch_subparser() {
    if [ "x$gpg_cmd" == "xexport" ]; then
        ___p_gpg_export "${gpg_cmd_args[@]}"
    elif [ "x$gpg_cmd" == "xgenerate" ]; then
        ___p_gpg_generate "${gpg_cmd_args[@]}"
    elif [ "x$gpg_cmd" == "ximport" ]; then
        ___p_gpg_import "${gpg_cmd_args[@]}"
    elif [ "x$gpg_cmd" == "xlist" ]; then
        ___p_gpg_list "${gpg_cmd_args[@]}"
    elif [ "x$gpg_cmd" == "xpassword" ]; then
        ___p_gpg_password "${gpg_cmd_args[@]}"
    elif [ "x$gpg_cmd" == "xtrust" ]; then
        ___p_gpg_trust "${gpg_cmd_args[@]}"
    elif [ ! -z "$gpg_cmd" ]; then
        _handle_dispatch_error "$gpg_cmd"
    else
        ___p_gpg_print_help
    fi
}
function ___p_gpg_generate_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 2 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            gpg_name="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "gpg_name=${gpg_name}"
            fi

        elif (( $_parse_args_positional_index == 1 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            gpg_email="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "gpg_email=${gpg_email}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_gpg_generate_print_help
        return 1
    fi
    return 0
}
function ___p_gpg_generate_print_help() {
    cat - << ___p_gpg_generate_print_help_EOF
Usage: p gpg generate [options] <gpg_name> <gpg_email>
generae a new GPG key

Arguments:
  gpg_name: name of the GPG key's owner
  gpg_email: email address for the GPG key

Options:
  --help, -h: Print this help text.
___p_gpg_generate_print_help_EOF
}
function ___p_gpg_import_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            gpg_path="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "gpg_path=${gpg_path}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_gpg_import_print_help
        return 1
    fi
    return 0
}
function ___p_gpg_import_print_help() {
    cat - << ___p_gpg_import_print_help_EOF
Usage: p gpg import [options] <gpg_path>
import a GPG key from a file

Arguments:
  gpg_path: path to the GPG key to import

Options:
  --help, -h: Print this help text.
___p_gpg_import_print_help_EOF
}
function ___p_gpg_export_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 2 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            gpg_id="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "gpg_id=${gpg_id}"
            fi

        elif (( $_parse_args_positional_index == 1 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            gpg_path="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "gpg_path=${gpg_path}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_gpg_export_print_help
        return 1
    fi
    return 0
}
function ___p_gpg_export_print_help() {
    cat - << ___p_gpg_export_print_help_EOF
Usage: p gpg export [options] <gpg_id> <gpg_path>
export a GPG key to a file

Arguments:
  gpg_id: identifier of the key to export
  gpg_path: path to write the key to

Options:
  --help, -h: Print this help text.
___p_gpg_export_print_help_EOF
}
function ___p_gpg_list_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            gpg_id="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "gpg_id=${gpg_id}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_gpg_list_print_help
        return 1
    fi
    return 0
}
function ___p_gpg_list_print_help() {
    cat - << ___p_gpg_list_print_help_EOF
Usage: p gpg list [options] [arguments.gpg_id]
list all keys tracked by GPG

Arguments:
  gpg_id: optionally list only keys matching id

Options:
  --help, -h: Print this help text.
___p_gpg_list_print_help_EOF
}
function ___p_gpg_password_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            gpg_id="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "gpg_id=${gpg_id}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_gpg_password_print_help
        return 1
    fi
    return 0
}
function ___p_gpg_password_print_help() {
    cat - << ___p_gpg_password_print_help_EOF
Usage: p gpg password [options] <gpg_id>
change the password on a key

Arguments:
  gpg_id: unique identifier for the GPG key

Options:
  --help, -h: Print this help text.
___p_gpg_password_print_help_EOF
}
function ___p_gpg_trust_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            gpg_id="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "gpg_id=${gpg_id}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_gpg_trust_print_help
        return 1
    fi
    return 0
}
function ___p_gpg_trust_print_help() {
    cat - << ___p_gpg_trust_print_help_EOF
Usage: p gpg trust [options] <gpg_id>
trust and sign the specified GPG key

Arguments:
  gpg_id: unique identifier for the GPG key

Options:
  --help, -h: Print this help text.
___p_gpg_trust_print_help_EOF
}
function ___p_cd_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--absolute" ] || [ "x$arg" == "x-absolute" ] || [ "x$arg" == "x-a" ]; then
            absolute="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "absolute=${absolute}"
            fi

        elif (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--relative" ] || [ "x$arg" == "x-relative" ] || [ "x$arg" == "x-r" ]; then
            relative="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "relative=${relative}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            cd_path="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "cd_path=${cd_path}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_cd_print_help
        return 1
    fi
    return 0
}
function ___p_cd_print_help() {
    cat - << ___p_cd_print_help_EOF
Usage: p cd [options] <cd_path>
change directories

Arguments:
  cd_path: path to change into; absolute if prefixed with '/' or --absolute is specified, else relative

Options:
  --help, -h: Print this help text.
  --absolute, -a: treat as an absolute path
  --relative, -r: treat as a relative path
___p_cd_print_help_EOF
}
function ___p_cp_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 2 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif [ "x$arg" == "x--force" ] || [ "x$arg" == "x-force" ] || [ "x$arg" == "x-f" ]; then
            force="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "force=${force}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            old_path="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "old_path=${old_path}"
            fi

        elif (( $_parse_args_positional_index == 1 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            new_path="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "new_path=${new_path}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_cp_print_help
        return 1
    fi
    return 0
}
function ___p_cp_print_help() {
    cat - << ___p_cp_print_help_EOF
Usage: p cp [options] <old_path> <new_path>
copy the contents of one file to another location

Arguments:
  old_path: existing path to copy from
  new_path: destination path to copy to

Options:
  --help, -h: Print this help text.
  --force, -f: silently overwrites destination if it exists
___p_cp_print_help_EOF
}
function ___p_ls_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif [ "x$arg" == "x--directory" ] || [ "x$arg" == "x-directory" ] || [ "x$arg" == "x-d" ]; then
            directory="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "directory=${directory}"
            fi

        elif [ "x$arg" == "x--all" ] || [ "x$arg" == "x-all" ] || [ "x$arg" == "x-a" ]; then
            all="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "all=${all}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            ls_paths+=("$arg")
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "ls_paths=${ls_paths[@]} | len=${#ls_paths[@]}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_ls_print_help
        return 1
    fi
    return 0
}
function ___p_ls_print_help() {
    cat - << ___p_ls_print_help_EOF
Usage: p ls [options] <ls_paths...>
list files and directories

Arguments:
  ls_paths: paths to inspect

Options:
  --help, -h: Print this help text.
  --directory, -d: list directories themselves, not their contents
  --all, -a: list contents as they appear in the file system, not hiding extensions
___p_ls_print_help_EOF
}
function ___p_mkdir_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif [ "x$arg" == "x--recursive" ] || [ "x$arg" == "x-recursive" ] || [ "x$arg" == "x-r" ]; then
            recursive="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "recursive=${recursive}"
            fi

        elif [ "x$arg" == "x--absolute" ] || [ "x$arg" == "x-absolute" ] || [ "x$arg" == "x-a" ]; then
            absolute="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "absolute=${absolute}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            mkdir_paths+=("$arg")
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "mkdir_paths=${mkdir_paths[@]} | len=${#mkdir_paths[@]}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_mkdir_print_help
        return 1
    fi
    return 0
}
function ___p_mkdir_print_help() {
    cat - << ___p_mkdir_print_help_EOF
Usage: p mkdir [options] <mkdir_paths...>
make a new directory

Arguments:
  mkdir_paths: paths to create as directories

Options:
  --help, -h: Print this help text.
  --recursive, -r: recrusively create the specified path
  --absolute, -a: treat the specified path as an relative to /, even if not prefixed by /
___p_mkdir_print_help_EOF
}
function ___p_mv_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 2 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            if (( $# > 2 )); then
                _parse_args_positional_index=$((_parse_args_positional_index + 1))
            fi
            mv_srcs+=("$arg")
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "mv_srcs=${mv_srcs[@]} | len=${#mv_srcs[@]}"
            fi

        elif (( $_parse_args_positional_index == 1 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            mv_dest="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "mv_dest=${mv_dest}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_mv_print_help
        return 1
    fi
    return 0
}
function ___p_mv_print_help() {
    cat - << ___p_mv_print_help_EOF
Usage: p mv [options] <mv_srcs...> <mv_dest>
move a file to another location

Arguments:
  mv_srcs: paths to items to move
  mv_dest: path to new location for the specified objects

Options:
  --help, -h: Print this help text.
___p_mv_print_help_EOF
}
function ___p_rm_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif [ "x$arg" == "x--recursive" ] || [ "x$arg" == "x-recursive" ] || [ "x$arg" == "x-r" ]; then
            recursive="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "recursive=${recursive}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            rm_paths="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "rm_paths=${rm_paths}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_rm_print_help
        return 1
    fi
    return 0
}
function ___p_rm_print_help() {
    cat - << ___p_rm_print_help_EOF
Usage: p rm [options] <rm_paths>
remove the specified path from the password store

Arguments:
  rm_paths: paths to remove

Options:
  --help, -h: Print this help text.
  --recursive, -r: recursively remove the specified paths
___p_rm_print_help_EOF
}
function ___p_cat_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif [ "x$arg" == "x--raw" ] || [ "x$arg" == "x-raw" ] || [ "x$arg" == "x-r" ]; then
            raw="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "raw=${raw}"
            fi

        elif [ "x$arg" == "x--json-only" ] || [ "x$arg" == "x-json-only" ] || [ "x$arg" == "x-j" ]; then
            json_only="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "json_only=${json_only}"
            fi

        elif [ "x$arg" == "x--password-only" ] || [ "x$arg" == "x-password-only" ] || [ "x$arg" == "x-p" ]; then
            password_only="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "password_only=${password_only}"
            fi

        elif [ "x$arg" == "x--no-color" ] || [ "x$arg" == "x-no-color" ] || [ "x$arg" == "x-n" ]; then
            color="false"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "color=${color}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            cat_paths+=("$arg")
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "cat_paths=${cat_paths[@]} | len=${#cat_paths[@]}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_cat_print_help
        return 1
    fi
    return 0
}
function ___p_cat_print_help() {
    cat - << ___p_cat_print_help_EOF
Usage: p cat [options] <cat_paths...>
show the contents of a password entry

Arguments:
  cat_paths: paths of password entries to display

Options:
  --help, -h: Print this help text.
  --raw, -r: raw, uncolorized, machine-readable output
  --json-only, -j: only output the json portion of these password entries, if present
  --password-only, -p: only output the first line of the password entry
  --no-color, -n: don't colorize the output
___p_cat_print_help_EOF
}
function ___p_edit_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            edit_path="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "edit_path=${edit_path}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_edit_print_help
        return 1
    fi
    return 0
}
function ___p_edit_print_help() {
    cat - << ___p_edit_print_help_EOF
Usage: p edit [options] <edit_path>
edit the contents of a file

Arguments:
  edit_path: path to the entry to open in an editor

Options:
  --help, -h: Print this help text.
___p_edit_print_help_EOF
}
function ___p_generate_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif [ "x${arg:0:9}" == "x--format=" ] || [ "x${arg:0:8}" == "x-format=" ]; then
            format="${arg#*=}"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "format=${format}"
            fi

        elif (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--format" ] || [ "x$arg" == "x-format" ] || [ "x$arg" == "x-f" ]; then
            format="$1"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "format=${format}"
            fi

            shift
        elif (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--random" ] || [ "x$arg" == "x-random" ] || [ "x$arg" == "x-r" ]; then
            random="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "random=${random}"
            fi

        elif (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--phrase" ] || [ "x$arg" == "x-phrase" ] || [ "x$arg" == "x-p" ]; then
            phrase="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "phrase=${phrase}"
            fi

        elif [ "x${arg:0:7}" == "x--save=" ] || [ "x${arg:0:6}" == "x-save=" ]; then
            save="${arg#*=}"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "save=${save}"
            fi

        elif (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--save" ] || [ "x$arg" == "x-save" ] || [ "x$arg" == "x-s" ]; then
            save="$1"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "save=${save}"
            fi

            shift
        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_generate_print_help
        return 1
    fi
    return 0
}
function ___p_generate_print_help() {
    cat - << ___p_generate_print_help_EOF
Usage: p generate [options]
generate a new password

Options:
  --help, -h: Print this help text.
  --format, -f <str>: format string for generated password
  --random, -r: generate a 30 alphanumeric character password
  --phrase, -p: generate a 3 word, 12 number phrase password
  --save, -s <str>: save generated password to the specified password entry
___p_generate_print_help_EOF
}
function ___p_json_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            local __tmp_json_cmd="$arg"

            if [ "x$__tmp_json_cmd" == "xget" ] || [ "x$__tmp_json_cmd" == "xg" ]; then
                json_cmd="get"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "json_cmd=${json_cmd}"
                fi

            elif [ "x$__tmp_json_cmd" == "xkinit" ] || [ "x$__tmp_json_cmd" == "xk" ]; then
                json_cmd="kinit"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "json_cmd=${json_cmd}"
                fi

            elif [ "x$__tmp_json_cmd" == "xretype" ] || [ "x$__tmp_json_cmd" == "xr" ] || [ "x$__tmp_json_cmd" == "xtype" ] || [ "x$__tmp_json_cmd" == "xt" ]; then
                json_cmd="retype"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "json_cmd=${json_cmd}"
                fi

            elif [ "x$__tmp_json_cmd" == "xset" ] || [ "x$__tmp_json_cmd" == "xs" ]; then
                json_cmd="set"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "json_cmd=${json_cmd}"
                fi

            else
                _handle_parse_error "json_cmd" "$__tmp_json_cmd"
            fi
        else
            json_cmd_args+=("$arg")
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "json_cmd_args=${json_cmd_args[@]} | len=${#json_cmd_args[@]}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_json_print_help
        return 1
    fi
    return 0
}
function ___p_json_print_help() {
    cat - << ___p_json_print_help_EOF
Usage: p json [options] <json_cmd> [vars.json_cmd_args...]
manipulate a JSON-encoded password file

Arguments:
  json_cmd: json manipulation action
    - get: get a key's value from a file's JSON data
    - set: set a key's value in a file's JSON data
    - retype: type the key's value from a file's JSON data
    - kinit: obtain a Kerberos ticket from information in the specified file's JSON data

Options:
  --help, -h: Print this help text.
___p_json_print_help_EOF
}
function ___p_json_dispatch_subparser() {
    if [ "x$json_cmd" == "xget" ]; then
        ___p_json_get "${json_cmd_args[@]}"
    elif [ "x$json_cmd" == "xkinit" ]; then
        ___p_json_kinit "${json_cmd_args[@]}"
    elif [ "x$json_cmd" == "xretype" ]; then
        ___p_json_retype "${json_cmd_args[@]}"
    elif [ "x$json_cmd" == "xset" ]; then
        ___p_json_set "${json_cmd_args[@]}"
    elif [ ! -z "$json_cmd" ]; then
        _handle_dispatch_error "$json_cmd"
    else
        ___p_json_print_help
    fi
}
function ___p_json_get_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 2 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            file="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "file=${file}"
            fi

        elif (( $_parse_args_positional_index == 1 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            key="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "key=${key}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_json_get_print_help
        return 1
    fi
    return 0
}
function ___p_json_get_print_help() {
    cat - << ___p_json_get_print_help_EOF
Usage: p json get [options] <file> <key>
get a key's value from a file's JSON data

Arguments:
  file: file to read
  key: key to read out of the file; defaults to password

Options:
  --help, -h: Print this help text.
___p_json_get_print_help_EOF
}
function ___p_json_set_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 3 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            file="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "file=${file}"
            fi

        elif (( $_parse_args_positional_index == 1 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            key="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "key=${key}"
            fi

        elif (( $_parse_args_positional_index == 2 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            value="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "value=${value}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_json_set_print_help
        return 1
    fi
    return 0
}
function ___p_json_set_print_help() {
    cat - << ___p_json_set_print_help_EOF
Usage: p json set [options] <file> <key> <value>
set a key's value in a file's JSON data

Arguments:
  file: file to write
  key: key to set in the file
  value: value of the key

Options:
  --help, -h: Print this help text.
___p_json_set_print_help_EOF
}
function ___p_json_retype_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 2 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            file="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "file=${file}"
            fi

        elif (( $_parse_args_positional_index == 1 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            key="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "key=${key}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_json_retype_print_help
        return 1
    fi
    return 0
}
function ___p_json_retype_print_help() {
    cat - << ___p_json_retype_print_help_EOF
Usage: p json retype [options] <file> <key>
type the key's value from a file's JSON data

Arguments:
  file: file to read
  key: key to read out of the file; defaults to password

Options:
  --help, -h: Print this help text.
___p_json_retype_print_help_EOF
}
function ___p_json_kinit_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            file="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "file=${file}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_json_kinit_print_help
        return 1
    fi
    return 0
}
function ___p_json_kinit_print_help() {
    cat - << ___p_json_kinit_print_help_EOF
Usage: p json kinit [options] <file>
obtain a Kerberos ticket from information in the specified file's JSON data

Arguments:
  file: file to read

Options:
  --help, -h: Print this help text.
___p_json_kinit_print_help_EOF
}
function ___p_find_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        find_args+=("$arg")
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "find_args=${find_args[@]} | len=${#find_args[@]}"
        fi


        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_find_print_help
        return 1
    fi
    return 0
}
function ___p_find_print_help() {
    cat - << ___p_find_print_help_EOF
Usage: p find [vars.find_args...]
list all files in the password store
___p_find_print_help_EOF
}
function ___p_locate_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            substr+=("$arg")
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "substr=${substr[@]} | len=${#substr[@]}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_locate_print_help
        return 1
    fi
    return 0
}
function ___p_locate_print_help() {
    cat - << ___p_locate_print_help_EOF
Usage: p locate [options] <substr...>
locate files and directories matching a pattern

Arguments:
  substr: substring to match in the path

Options:
  --help, -h: Print this help text.
___p_locate_print_help_EOF
}
function ___p_search_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 1 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            if (( $# <= 1 )); then
                do_shift="false"
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "do_shift=${do_shift}"
                fi

                _parse_args_positional_index=$((_parse_args_positional_index + 1))
            else
                if (( $# <= 2 )); then
                    _parse_args_positional_index=$((_parse_args_positional_index + 1))
                fi
                grep_options+=("$arg")
                if [ ! -z "$SHARG_VERBOSE" ]; then
                    echo "grep_options=${grep_options[@]} | len=${#grep_options[@]}"
                fi

            fi
        elif (( $_parse_args_positional_index == 1 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            search_regex="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "search_regex=${search_regex}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_search_print_help
        return 1
    fi
    return 0
}
function ___p_search_print_help() {
    cat - << ___p_search_print_help_EOF
Usage: p search [options] [arguments.grep_options...] <search_regex>
search the contents of files for a match

Arguments:
  grep_options: additional arguments to pass to grep
  search_regex: regex to pass to grep

Options:
  --help, -h: Print this help text.
___p_search_print_help_EOF
}
function ___p_decrypt_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 2 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            entry="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "entry=${entry}"
            fi

        elif (( $_parse_args_positional_index == 1 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            result_path="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "result_path=${result_path}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_decrypt_print_help
        return 1
    fi
    return 0
}
function ___p_decrypt_print_help() {
    cat - << ___p_decrypt_print_help_EOF
Usage: p decrypt [options] <entry> <result_path>
extract (decrypt) a file in the password store

Arguments:
  entry: vault entry to decrypt
  result_path: filesystem path to store the decrypted file at

Options:
  --help, -h: Print this help text.
___p_decrypt_print_help_EOF
}
function ___p_encrypt_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 2 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            file_path="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "file_path=${file_path}"
            fi

        elif (( $_parse_args_positional_index == 1 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            entry="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "entry=${entry}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_encrypt_print_help
        return 1
    fi
    return 0
}
function ___p_encrypt_print_help() {
    cat - << ___p_encrypt_print_help_EOF
Usage: p encrypt [options] <file_path> <entry>
store a file into the password store

Arguments:
  file_path: filesystem path to read
  entry: vault entry to encrypt to

Options:
  --help, -h: Print this help text.
___p_encrypt_print_help_EOF
}
function ___p_open_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    if (( $# < 2 )); then
        parse_args_print_help="true"
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "parse_args_print_help=${parse_args_print_help}"
        fi

    fi

    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--read-only" ] || [ "x$arg" == "x-read-only" ] || [ "x$arg" == "x-r" ]; then
            read_only="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "read_only=${read_only}"
            fi

        elif (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--no-lock" ] || [ "x$arg" == "x-no-lock" ] || [ "x$arg" == "x-l" ]; then
            no_lock="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "no_lock=${no_lock}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            open_entry="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "open_entry=${open_entry}"
            fi

        elif (( $_parse_args_positional_index == 1 )); then
            open_command+=("$arg")
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "open_command=${open_command[@]} | len=${#open_command[@]}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_open_print_help
        return 1
    fi
    return 0
}
function ___p_open_print_help() {
    cat - << ___p_open_print_help_EOF
Usage: p open [options] <open_entry> <open_command...>
run a command to view a file in the password store

Arguments:
  open_entry: password entry to open
  open_command: command

Options:
  --help, -h: Print this help text.
  --read-only, -r: do not save changes made to the file
  --no-lock, -l: do not try to acquire a lock before opening the file
___p_open_print_help_EOF
}
function ___p_git_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        git_args+=("$arg")
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "git_args=${git_args[@]} | len=${#git_args[@]}"
        fi


        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_git_print_help
        return 1
    fi
    return 0
}
function ___p_git_print_help() {
    cat - << ___p_git_print_help_EOF
Usage: p git [vars.git_args...]
run git commands in the password store
___p_git_print_help_EOF
}
function ___p_through_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        pass_args+=("$arg")
        if [ ! -z "$SHARG_VERBOSE" ]; then
            echo "pass_args=${pass_args[@]} | len=${#pass_args[@]}"
        fi


        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_through_print_help
        return 1
    fi
    return 0
}
function ___p_through_print_help() {
    cat - << ___p_through_print_help_EOF
Usage: p pass [vars.pass_args...]
pass a command through to pass (for accessing extensions)
___p_through_print_help_EOF
}
function ___p_sync_parse_args() {
    local parse_args_print_help="false"
    local _parse_args_positional_index="0"
    while (( $# > 0 )); do
        local arg="$1"
        local do_shift="true"

        if (( $_parse_args_positional_index == 0 )) && [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] || [ "x$arg" == "x-h" ]; then
            parse_args_print_help="true"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "parse_args_print_help=${parse_args_print_help}"
            fi

        elif (( $_parse_args_positional_index == 0 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            branch="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "branch=${branch}"
            fi

        elif (( $_parse_args_positional_index == 1 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            origin="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "origin=${origin}"
            fi

        elif (( $_parse_args_positional_index == 2 )); then
            _parse_args_positional_index=$((_parse_args_positional_index + 1))
            remote="$arg"
            if [ ! -z "$SHARG_VERBOSE" ]; then
                echo "remote=${remote}"
            fi

        fi

        if [ "x$do_shift" == "xtrue" ]; then
            shift
        fi
    done

    if [ "x$parse_args_print_help" == "xtrue" ]; then
        ___p_sync_print_help
        return 1
    fi
    return 0
}
function ___p_sync_print_help() {
    cat - << ___p_sync_print_help_EOF
Usage: p sync [options] [arguments.branch] [arguments.origin] [arguments.remote]
sync a local branch with a remote one

Arguments:
  branch: local branch to sync from; defaults to the current branch
  origin: remote origin to sync to; defaults to origin
  remote: remote branch to sync to; defaults to master

Options:
  --help, -h: Print this help text.
___p_sync_print_help_EOF
}
