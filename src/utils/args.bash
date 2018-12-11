# Process command line arguments
function __p_args() {
    local found_command="false"

    for count in $(seq 1 $#); do
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
            # copy command
            _pc_copy="true"
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

    for arg in "$@"; do
        if [ "x$arg" == "x--verbose" ]; then
            # enables global verbose mode if it is persent in the command
            # arguments
            _p_verbose="x"
        else
            _p_remaining+=("$arg")
        fi
    done

    if [ "x$found_command" == "xfalse" ]; then
        _pc_help="true"
    fi
}