export __CUR_DIR="$(dirname "${BASH_SOURCE[0]}")"
source "$__CUR_DIR/common.bash"

function test_p_encrypt_decrypt() {
    (
        # Test with git
        __p create -n "p-test"

        echo "hello" | __p encrypt - /a
        echo "there" | __p encrypt - /b

        t_expect_dir "$pass_dir"
        t_expect_file "$pass_dir/a.gpg"
        t_expect_file "$pass_dir/b.gpg"

        __p decrypt /a "$HOME/a"
        __p decrypt --permissions 400 /b "$HOME/b"

        t_expect_file "$HOME/a"
        t_expect_file "$HOME/b"
        t_expect_string_in_file "$HOME/a" "hello"
        t_expect_string_in_file "$HOME/b" "there"
        t_expect_permissions "$HOME/b" 400

        t_expect_done
        c_rm "$pass_dir"
    )
}
