export __CUR_DIR="$(dirname "${BASH_SOURCE[0]}")"
export __BIN_DIR="$__CUR_DIR/../bin"

source "$__CUR_DIR/expect.bash"


function __p() {
    "$__BIN_DIR/p" --password-store-dir "$pass_dir" --gpg-home-dir "$gpg_dir" "$@"
}

function test_p_create() {
    (
        local base_dir="$(t_dir)"
        local pass_dir="$base_dir/pass"
        local gpg_dir="$base_dir/gpg"
        mkdir -p "$gpg_dir"

        __p gpg generate "p-test" "ptest@example.com" "\"\""
        t_expect_dir "$gpg_dir"
        t_expect_file "$gpg_dir/pubring.kbx"
        t_expect_file "$gpg_dir/trustdb.gpg"

        __p create "p-test"
        t_expect_dir "$pass_dir"
        t_expect_file "$pass_dir/.gpg-id"
        t_expect_dir "$pass_dir/.git"
        t_expect_string_in_file "$pass_dir/.gpg-id" "p-test"

        t_expect_stats
        rm -rf "$base_dir"
    )
    (
        local base_dir="$(t_dir)"
        local pass_dir="$base_dir/pass"
        local gpg_dir="$base_dir/gpg"
        mkdir -p "$gpg_dir"

        __p gpg generate "p-test" "ptest@example.com" "\"\""
        t_expect_dir "$gpg_dir"
        t_expect_file "$gpg_dir/pubring.kbx"
        t_expect_file "$gpg_dir/trustdb.gpg"

        __p create -n "p-test"
        t_expect_dir "$pass_dir"
        t_expect_file "$pass_dir/.gpg-id"
        t_expect_string_in_file "$pass_dir/.gpg-id" "p-test"

        t_expect_stats
        rm -rf "$base_dir"
    )
}

function test_p_insert() {

}

test_p_create
