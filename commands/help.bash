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
