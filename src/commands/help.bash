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
    echo " - ls: list files and directories"
    echo " - copy: copy the contents of one file to another location"
    echo " - cat: show the contents of a file"
    echo " - cd: change directories"
    echo " - edit: edit a file"
    echo " - json: perform simple get/set manipulations on a file"
    echo " - mkdir: make a directory"
    echo ""
    echo "For more information about a particular command, including its"
    echo "command line arguments and subcommands, pass --help to the"
    echo "command."
}
