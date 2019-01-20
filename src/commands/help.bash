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
    echo " - cp: copy the contents of one file to another location"
    echo " - mv: move a file to another location"
    echo " - rm: remove the specified path from the password store"
    echo " - cat: show the contents of a file"
    echo " - cd: change directories"
    echo " - edit: edit a file"
    echo " - json: perform simple get/set manipulations on a file"
    echo " - mkdir: make a directory"
    echo " - git: run git commands in the password store"
    echo " - encrypt: store a file in the password store"
    echo " - decrypt: extract a file in the password store"
    echo " - open: run a command to view a file in the password store"
    echo " - pass: pass command through to pass (for accessing extensions)"
    echo " - clone: create a store from a git repository"
    echo ""
    echo "For more information about a particular command, including its"
    echo "command line arguments and subcommands, pass --help to the"
    echo "command."
}
