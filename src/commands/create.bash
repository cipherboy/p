function ___p_create() {
    __v "Value of _pc_create: $_pc_create"
    if [ "$_pc_create" == "false" ]; then
        return 0
    fi

    local gpg_id=""
    local seen_gpg_id="false"

    local init_git="true"
    local help="false"
    local gpg_error="false"

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
        __v "No ~/.gitconfig present -- refusing to initialize git"
        init_git="false"
    fi

    if [ ! -e "$_p_pass_dir/.gpg-id" ]; then
        __gpg --list-keys "$gpg_id" >/dev/null 2>&1
        local ret=$?
        if [ "x$gpg_id" == "x" ] || (( ret != 0 )); then
            help="true"
            gpg_error="true"
        fi
    fi

    if [ "$help" == "true" ]; then
        echo "Usage: p create [options] <gpg_id>"
        echo "Create a new password store or progressively reinitialize an existing one."
        echo ""
        echo "Options:"
        echo "--no-git, -n: don't create the password store with git."

        if [ "$gpg_error" == "true" ]; then
            echo ""
            __e "Unknown gpg key: \`$gpg_id\`"
            return 1
        fi

        return 0
    fi

    if [ ! -d "$_p_pass_dir/.p" ]; then
        mkdir -p "$_p_pass_dir/.p"
    fi

    if [ "$init_git" == "true" ]; then
        pushd "$_p_pass_dir" >/dev/null
            git init >/dev/null
            git add -A >/dev/null
            git commit -m "Store repository contents" >/dev/null
        popd >/dev/null
    fi

    if [ ! -e "$_p_pass_dir/.gpg-id" ]; then
        __pass init "$gpg_id"
    fi

    if [ -d "$_p_pass_dir/.git" ]; then
        if ! grep -qs "^\*\.lock$" "$_p_pass_dir/.gitignore"; then
            echo "*.lock" > "$_p_pass_dir/.gitignore"
            __pass git add "$_p_pass_dir/.gitignore" >/dev/null
            __pass git commit -m "Add *.lock to .gitignore" >/dev/null
        fi
    fi

    if [ ! -d "$_p_pass_dir/.p/keys" ]; then
        _pc_keys="true" ___p_keys init "$(cat "$_p_pass_dir/.gpg-id")"
    fi
}
