# Print help information; this is the most complete documentation about
# using the p interface there is outside of reading the script.
function ___p_help() {
    __v "Value of _pc_help: $_pc_help"
    if [ "$_pc_help" == "false" ]; then
        return
    fi

    echo "Usage: p [global options] <cmd> [args]"
    echo ""
    echo "p - version $_p_version"
    echo "https://github.com/cipherboy/p"
    echo ""
    echo ""
    echo "Available commands:"
    echo " Setup:"
    echo "  - clone: create a store from a git repository"
    echo "  - create: create a store from scratch"
    echo "  - keys: manage keys used to encrypt passwords"
    echo ""
    echo " Basic navigation:"
    echo "  - cd: change directories"
    echo "  - cp: copy the contents of one file to another location"
    echo "  - ls: list files and directories"
    echo "  - mkdir: make a directory"
    echo "  - mv: move a file to another location"
    echo "  - rm: remove the specified path from the password store"
    echo ""
    echo " Managing passwords:"
    echo "  - cat: show the contents of a file"
    echo "  - edit: edit a file"
    echo "  - generate: generate a new password"
    echo "  - json: perform simple get/set manipulations on a file"
    echo ""
    echo " Search commands:"
    echo "  - find: list all files in the password store"
    echo "  - locate: list files and directories matching a pattern"
    echo "  - search: search the contents of files for a match"
    echo ""
    echo " Storing files:"
    echo "  - decrypt: extract a file in the password store"
    echo "  - encrypt: store a file in the password store"
    echo "  - open: run a command to view a file in the password store"
    echo ""
    echo " Other commands:"
    echo "  - git: run git commands in the password store"
    echo "  - pass: pass command through to pass (for accessing extensions)"
    echo ""
    echo "For more information about a particular command, including its"
    echo "command line arguments and subcommands, pass --help to the"
    echo "command."
    echo ""
    echo ""
    echo "Global options:"
    echo " --gpg-home-dir <dir>: gpg home directory to use"
    echo " --password-store-dir <dir>: password store directory to use"
    echo " --verbose: enable verbose output for debugging"
}
