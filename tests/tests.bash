export __CUR_DIR="$(dirname "${BASH_SOURCE[0]}")"
export __BIN_DIR="$__CUR_DIR/../bin"

source "$__CUR_DIR/common.bash"
source "$__CUR_DIR/expect.bash"

source "$__CUR_DIR/t_setup.bash"

function main() {
    local fake_home="$(c_dir)"
    local gpg_dir=""

    export HOME="$fake_home"
    c_home_start
    (
        set -e

        test_p_gpg_generate

        gpg_dir="$(c_dir)"
        gpg_start "p-test" "ptest@example.com" "\"\""

        test_p_create
    )

    gpg_done
    c_home_done
}

unset P_USER
unset P_HOST

"$__CUR_DIR"/../build.py
main
