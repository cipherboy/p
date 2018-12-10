# Prints the output of jq as a "properly formatted" pass entry; in
# particular, print the contents of the password prior to the JSON
# structure. Note that the password is updated to match the JSON
# structure. Meant to be used as part of a pipe chain.
function __p_print_json() {
    # Note that this buffers until it has read all input up to this
    # point. This means that __p_print_json will stall if the input
    # hasn't finished.
    local stdin="$(cat -)"
    echo "$stdin" | jq -r -M '.password'
    echo "$stdin" | jq -r -M '.'
}
