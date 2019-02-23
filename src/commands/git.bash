# Function to change directories. Note that, as p is usually invoked from a
# new bash process, a function usually has to be created to actually change
# directories:
#
# function pcd() {
#   export P_CWD="$(p cd "$1")"'
# }
function ___p_git() {
    __pass git "$@"
}
