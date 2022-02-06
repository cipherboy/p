export __CUR_DIR="$(dirname "${BASH_SOURCE[0]}")"
export __BIN_DIR="$__CUR_DIR/../bin"

source "$__CUR_DIR/common.bash"
source "$__CUR_DIR/expect.bash"

source "$__CUR_DIR/t_setup.bash"
source "$__CUR_DIR/t_encrypt_decrypt.bash"

function main() {
    # Set $HOME in a subshell.
    (
        local fake_home="$(c_dir)"
        local gpg_dir=""
        local pass_dir=""

        export HOME="$fake_home"
        c_home_start
        (
            set -e

            test_p_gpg_generate

            gpg_dir="$(c_dir)"
            gpg_start "p-test" "ptest@example.com"

            test_p_create

            gpg_done

            pass_dir="$(c_dir)/pass_git"
            gpg_dir="$HOME/.gnupg"
            gpg_start "p-test" "ptest@example.com"

            test_p_encrypt_decrypt
        )

        gpg_done
        c_home_done
    )

    gpg-connect-agent reloadagent /bye
}

unset P_USER
unset P_HOST

"$__CUR_DIR"/../build.py
main
