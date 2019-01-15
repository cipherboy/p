# Function to change directories. Note that, as p is usually invoked from a
# new bash process, a function usually has to be created to actually change
# directories:
#
# function pcd() {
#   export P_CWD="$(p cd "$1")"'
# }
function ___p_git() {
    __v "Value of _pc_git: $_pc_git"
    if [ "$_pc_git" == "false" ]; then
        return 0
    fi

    __pass git "$@"
}
