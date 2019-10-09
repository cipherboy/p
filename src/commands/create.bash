function ___p_create() {
    local gpg_id=""
    local init_git="true"
    local gpg_error="false"

    ___p_create_parse_args "$@"
    ret=$?

    if (( ret != 0 )); then
        return $ret
    fi

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

    if [ "$gpg_error" == "true" ]; then
        ___p_create_print_help
        echo ""
        __e "Unknown gpg key: \`$gpg_id\`"
        return 1
    fi

    if [ ! -d "$_p_pass_dir/.p" ]; then
        mkdir -p "$_p_pass_dir/.p"
    fi

    if [ "$init_git" == "true" ]; then
        pushd "$_p_pass_dir" >/dev/null
            __pass git init >/dev/null
            __pass git add -A >/dev/null
            __pass git commit -m "Store repository contents" >/dev/null
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
        ___p_keys init "$(cat "$_p_pass_dir/.gpg-id")"
    fi
}
