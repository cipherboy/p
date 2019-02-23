export __CUR_DIR="$(dirname "${BASH_SOURCE[0]}")"
source "$__CUR_DIR/common.bash"

function test_p_gpg_generate() {
    local base_dir="$(c_dir)"
    local gpg_dir="$base_dir/gpg"

    (
        gpg_start "p-test" "ptest@example.com" "\"\""
        t_expect_dir "$gpg_dir"
        t_expect_file "$gpg_dir/pubring.kbx"
        t_expect_dir "$gpg_dir/private-keys-v1.d"

        t_expect_done
        c_rm "$gpg_dir"
    )
}

function test_p_create() {
    local base_dir="$(c_dir)"
    (
        # Test with git
        local pass_dir="$base_dir/pass_git"
        __p create "p-test"
        t_expect_dir "$pass_dir"
        t_expect_file "$pass_dir/.gpg-id"
        t_expect_dir "$pass_dir/.git"
        t_expect_dir "$pass_dir/.p"
        t_expect_dir "$pass_dir/.p/keys"
        t_expect_file "$pass_dir/.p/keys/config.json.gpg"
        t_expect_string_in_file "$pass_dir/.gpg-id" "p-test"

        t_expect_done
        c_rm "$pass_dir"
    )
    (
        # Test without git
        local pass_dir="$base_dir/pass_no_git"
        mkdir -p "$gpg_dir"

        __p create -n "p-test"
        t_expect_dir "$pass_dir"
        t_expect_file "$pass_dir/.gpg-id"
        t_expect_dir "$pass_dir/.p"
        t_expect_dir "$pass_dir/.p/keys"
        t_expect_file "$pass_dir/.p/keys/config.json.gpg"
        t_expect_string_in_file "$pass_dir/.gpg-id" "p-test"

        t_expect_done
        c_rm "$pass_dir"
    )
    (
        # Test progressive improvements
        local pass_dir="$base_dir/pass_no_git"
        mkdir -p "$gpg_dir"

        __p create -n "p-test"
        t_expect_dir "$pass_dir"
        t_expect_file "$pass_dir/.gpg-id"
        t_expect_dir "$pass_dir/.p"
        t_expect_dir "$pass_dir/.p/keys"
        t_expect_file "$pass_dir/.p/keys/config.json.gpg"
        t_expect_string_in_file "$pass_dir/.gpg-id" "p-test"

        __p create
        t_expect_dir "$pass_dir/.git"

        t_expect_done
        c_rm "$pass_dir"
    )

    c_rm "$base_dir"
}
