function ___p_clone() {
    if (( $# != 1 )) || [ "x$1" == "x--help" ] || [ "x$1" == "x-help" ] ||
            [ "x$1" == "x-h" ] || [ -d "$_p_pass_dir" ]; then
        echo "Usage: p clone <uri>"
        echo ""
        echo "Creates a new password store in the directory pointed to by"
        echo "\`\$PASSWORD_STORE_DIR\` (currently \`$_p_pass_dir\`) by"
        echo "cloning the remote git repository specified by <uri>."

        if [ -d "$_p_pass_dir" ]; then
            echo ""
            echo "Error: Directory currently exists. Please specify a location"
            echo "that does not yet exist in \`\$PASSWORD_STORE_DIR\`."
        fi

        return 1
    fi

    git clone "$1" "$_p_pass_dir"
}
