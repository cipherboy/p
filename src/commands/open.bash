function ___p_open() {
    __v "Value of _pc_open: $_pc_open"
    if [ "$_pc_open" == "false" ]; then
        return 0
    fi

    local name=""
    local seen_name="false"
    local command=""
    local seen_command="false"
    local args=()

    local help="false"
    local read_only="false"
    local lock="true"

    while (( $# > 0 )); do
        local arg="$1"
        shift

        if [ "$seen_name" == "false" ]; then
            if [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] ||
                    [ "x$arg" == "xhelp" ] || [ "x$arg" == "x-h" ]; then
                help="true"
            elif [ "x$arg" == "x--read-only" ] || [ "x$arg" == "x--readonly" ] ||
                    [ "x$arg" == "x-read-only" ] || [ "x$arg" == "x-readonly" ] ||
                    [ "x$arg" == "x--ro" ] || [ "x$arg" == "x-ro" ] ||
                    [ "x$arg" == "x-r" ]; then
                read_only="true"
            elif [ "x$arg" == "x--no-lock" ] || [ "x$arg" == "x-no-lock" ] ||
                    [ "x$arg" == "x-n" ]; then
                lock="false"
            elif [ "x$arg" == "x--" ]; then
                continue
            else
                name="$arg"
                seen_name="true"
            fi
        elif [ "x$arg" == "x--" ]; then
            continue
        elif [ "$seen_command" == "false" ]; then
            command="$arg"
            seen_command="true"
        else
            args+=("$arg")
        fi
    done

    if [ "$help" == "true" ] || [ "$seen_name" == "false" ] ||
            [ "$seen_command" == "false" ]; then
        echo "Usage: p open [options] <name> [--] <command> [<args...>]"
        echo ""
        echo "Decrypt the entry <name>, storing it in a temporary location;"
        echo "execute <command> with <args>, replacing '{}' with the decrypted"
        echo "file location. When <command> completes, re-encrypt the file to"
        echo "<name>."
        echo ""
        echo "Options:"
        echo "    --read-only: do not save changes made to the file."
        echo "    --no-lock: do not try to acquire a lock first."
        echo ""
        echo "If {} isn't specified in the arguments, the temporary path is"
        echo "appended to the command line arguments"

        return 1
    fi

    local tmpdir="$(__p_mk_secure_tmp)"
    local basename="$(basename "$name")"
    local tmp="$tmpdir/$basename"

    local processed_args=()
    local seen_filename="false"

    # Process arguments, replacing {} with the filename in the argument,
    # if present.
    for (( index=0; index<"${#args[@]}"; index++ )); do
        local arg="${args[$index]}"
        local processed_arg="${arg/\{\}/$tmp}"

        if [ "x$processed_arg" != "x$arg" ]; then
            seen_filename="true"
        fi

        processed_args+=("$processed_arg")
    done

    if [ "$seen_filename" == "false" ]; then
        # Haven't seen the magical substring ('{}'), so append the temporary
        # file path.
        processed_args+=("$tmp")
    fi

    if [ "$read_only" == "false" ] && [ "$lock" = "true" ]; then
        if ! __p_lock "$name"; then
            __e "Error acquiring lock for file."
            __e "  To remove the lock file, run \`p unlock $name\`."
            __e "  To ignore the lock file, specify the --no-lock option."
            return 1
        fi
    fi

    _pc_decrypt="true" ___p_decrypt "$name" "$tmp"
    "$command" "${processed_args[@]}"

    if [ "$read_only" == "false" ]; then
        _pc_encrypt="true" ___p_encrypt "$tmp" "$name"

        if [ "$lock" == "true" ]; then
            __p_unlock "$name"
        fi
    fi

    __p_rm_secure_tmp "$tmp"
}
