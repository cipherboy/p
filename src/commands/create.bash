function ___p_create() {
    __v "Value of _pc_create: $_pc_create"
    if [ "$_pc_create" == "false" ]; then
        return 0
    fi

    local gpg_id=""
    local seen_gpg_id="false"

    local init_git="true"
    local help="false"

    while (( $# > 0 )); do
        local arg="$1"
        shift

        if [ "x$arg" == "x--help" ] || [ "x$arg" == "x-help" ] ||
                [ "x$arg" == "x-h" ]; then
            help="true"
        elif [ "x$arg" == "x--no-git" ] || [ "x$arg" == "x-no-git" ] ||
                [ "x$arg" == "x--ng" ] || [ "x$arg" == "x-ng" ] ||
                [ "x$arg" == "x-n" ]; then
            init_git="false"
        elif [ "$seen_gpg_id" == "false" ]; then
            gpg_id="$arg"
            seen_gpg_id="true"
        else
            __e "Unrecognized argument: $arg"
            help="true"
        fi
    done

    if [ ! -e "$HOME/.gitconfig" ]; then
        init_git="false"
    fi

    gpg2 --list-keys "$gpg_id" >/dev/null 2>&1
    local ret=$?

    if [ "$help" == "true" ] || [ "x$gpg_id" == "x" ] || (( ret != 0 )) ||
            [ -d "$_p_pass_dir" ]; then
        echo "Usage: p create [options] <gpg_id>"
        echo "Create a new password store."
        echo ""
        echo "Options:"
        echo "--no-git, -n: don't create the password store with git."

        if [ "x$gpg_id" != "x" ] && (( ret != 0 )); then
            echo ""
            __e "Unknown gpg key: \`$gpg_id\`"
            return 1
        fi

        if [ -d "$_p_pass_dir" ]; then
            echo ""
            __e "Password directory \`$_p_pass_dir\` already exists."
            __e "Please choose a different directory."
            return 1
        fi

        return 0
    fi

    mkdir -p "$_p_pass_dir/.p"

    if [ "$init_git" == "true" ]; then
        pushd "$_p_pass_dir" >/dev/null
            git init
        popd >/dev/null
    fi

    __pass init "$gpg_id"
}
