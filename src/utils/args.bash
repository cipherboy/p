# Process command line arguments
function __p_args() {
    local found_command="false"

    while (( $# > 0 )); do
        local arg="$1"
        shift

        if [ "x$arg" == "xhelp" ] || [ "x$arg" == "x--help" ] ||
                [ "x$arg" == "x-h" ]; then
            # help command
            _pc_help="true"
            found_command="true"
        elif [ "x$arg" == "xlist" ] || [ "x$arg" == "xls" ] ||
                [ "x$arg" == "xl" ]; then
            # ls command
            _pc_ls="true"
            found_command="true"
        elif [ "x$arg" == "xla" ]; then
            # ls command with all argument
            _pc_ls="true"
            found_command="true"
            _p_remaining+=("--all")
        elif [ "x$arg" == "xld" ]; then
            # ls command with dir argument
            _pc_ls="true"
            found_command="true"
            _p_remaining+=("--dir")
        elif [ "x$arg" == "xcopy" ] || [ "x$arg" == "xcp" ]; then
            # cp command
            _pc_cp="true"
            found_command="true"
        elif [ "x$arg" == "xmove" ] || [ "x$arg" == "xmv" ]; then
            # mv command
            _pc_mv="true"
            found_command="true"
        elif [ "x$arg" == "xremove" ] || [ "x$arg" == "xrm" ]; then
            # rm command
            _pc_rm="true"
            found_command="true"
        elif [ "x$arg" == "xshow" ] || [ "x$arg" == "xcat" ] ||
                [ "x$arg" == "xc" ]; then
            # cat command
            _pc_cat="true"
            found_command="true"
        elif [ "x$arg" == "xedit" ] || [ "x$arg" == "xe" ]; then
            # edit command
            _pc_edit="true"
            found_command="true"
        elif [ "x$arg" == "xjson" ] || [ "x$arg" == "xj" ]; then
            # json command
            _pc_json="true"
            found_command="true"
        elif [ "x$arg" == "xget" ] || [ "x$arg" == "xg" ] ||
                [ "x$arg" == "xjg" ]; then
            # json command with get subcommand
            _pc_json="true"
            found_command="true"
            _p_remaining+=("get")
        elif [ "x$arg" == "xset" ] || [ "x$arg" == "xs" ] ||
                [ "x$arg" == "xjs" ]; then
            # json command with set subcommand
            _pc_json="true"
            found_command="true"
            _p_remaining+=("set")
        elif [ "x$arg" == "xmkdir" ] || [ "x$arg" == "xm" ]; then
            # mkdir command
            _pc_mkdir="true"
            found_command="true"
        elif [ "x$arg" == "xcd" ]; then
            # cd command
            _pc_cd="true"
            found_command="true"
        elif [ "x$arg" == "xgit" ] || [ "x$arg" == "xgt" ]; then
            # git command
            _pc_git="true"
            found_command="true"
        elif [ "x$arg" == "xgts" ]; then
            # git command with status subcommand
            _pc_git="true"
            found_command="true"
            _p_remaining+=("status")
        elif [ "x$arg" == "xgtl" ]; then
            # git command with log subcommand
            _pc_git="true"
            found_command="true"
            _p_remaining+=("log")
        elif [ "x$arg" == "xgtp" ]; then
            # git command with push subcommand
            _pc_git="true"
            found_command="true"
            _p_remaining+=("push")
        elif [ "x$arg" == "xgtu" ]; then
            # git command with pull subcommand
            _pc_git="true"
            found_command="true"
            _p_remaining+=("pull")
        elif [ "x$arg" == "xencrypt" ]; then
            # encrypt command
            _pc_encrypt="true"
            found_command="true"
        elif [ "x$arg" == "xdecrypt" ]; then
            # decrypt command
            _pc_decrypt="true"
            found_command="true"
        elif [ "x$arg" == "xopen" ]; then
            # open command
            _pc_open="true"
            found_command="true"
        elif [ "x$arg" == "xthrough" ] || [ "x$arg" == "xpass" ] ||
                [ "x$arg" == "xthru" ] || [ "x$arg" == "xt" ]; then
            # passthrough command
            _pc_through="true"
            found_command="true"
        elif [ "x$arg" == "xclone" ]; then
            # clone command
            _pc_clone="true"
            found_command="true"
        elif [ "x$arg" == "xcreate" ]; then
            # create command
            _pc_create="true"
            found_command="true"
        elif [ "x$arg" == "xlocate" ] || [ "x$arg" == "xlt" ]; then
            # locate command
            _pc_locate="true"
            found_command="true"
        elif [ "x$arg" == "xfind" ]; then
            # find command
            _pc_find="true"
            found_command="true"
        elif [ "x$arg" == "xgenerate" ] || [ "x$arg" == "xgen" ]; then
            # generate command
            _pc_generate="true"
            found_command="true"
        elif [ "x$arg" == "xkeys" ] || [ "x$arg" == "xkey" ]; then
            # keys command
            _pc_keys="true"
            found_command="true"
        elif [ "x$arg" == "xgroups" ] || [ "x$arg" == "xgroup" ]; then
            # keys command with groups subcommand
            _pc_keys="true"
            found_command="true"
            _p_remaining+=("groups")
        elif [ "x$arg" == "xdirs" ] || [ "x$arg" == "xdir" ]; then
            # keys command with dirs subcommand
            _pc_keys="true"
            found_command="true"
            _p_remaining+=("dirs")
        elif [ "x$arg" == "xsearch" ] || [ "x$arg" == "xgrep" ]; then
            # search command
            _pc_search="true"
            found_command="true"
        elif [ "x$arg" == "x--password-store-dir" ]; then
            _p_pass_dir="$1"
            shift
        elif [ "x$arg" == "x--gpg-home-dir" ]; then
            _p_pass_gpg_dir="$1"
            shift
        elif [ "x$arg" == "x--verbose" ]; then
            # enables global verbose mode
            _p_verbose="x"
        else
            # Unknown command
            echo "Unknown global option or argument: $arg"
            _pc_help="true"
            return 0
        fi

        if [ "x$found_command" == "xtrue" ]; then
            # We don't currently support running multiple commands so quit
            # trying to parse commands.
            break
        fi
    done

    while (( $# > 0 )); do
        local arg="$1"
        shift

        if [ "x$arg" == "x--verbose" ]; then
            # enables global verbose mode if it is persent in the command
            # arguments
            _p_verbose="x"
        elif [ "x$arg" == "x--password-store-dir" ]; then
            _p_pass_dir="$1"
            shift
        elif [ "x$arg" == "x--gpg-home-dir" ]; then
            _p_pass_gpg_dir="$1"
            shift
        else
            _p_remaining+=("$arg")
        fi
    done

    if [ "x$found_command" == "xfalse" ]; then
        _pc_help="true"
    fi
}
