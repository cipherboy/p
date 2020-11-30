export __CUR_DIR="$(dirname "${BASH_SOURCE[0]}")"
export __BIN_DIR="$__CUR_DIR/../bin"

function __v() {
    if [ "$DEBUG" ]; then
        echo "v:" "$@" 1>&2
    fi
}

function __e() {
    echo "e:" "$@" 1>&2
}

function c_dir() {
    local dir="$(mktemp -d)"
    local user="$(id --user)"
    local group="$(id --group)"

    chown -R "$user:$group" "$dir"
    chmod -R 700 "$dir"

    __v "c_dir: $dir"
    echo "$dir"
}

function c_home_start() {
    __v "Creating: HOME=$HOME"
    mkdir -p "$HOME/.git"
    git config --global user.name "Password Test"
    git config --global user.email "ptest@example.com"
}

function c_home_done() {
    __v "Removing: HOME=$HOME"
    c_rm "$HOME"
}

function __p() {
    if [ "x$pass_dir" != "x" ]; then
        __v "$__BIN_DIR/p" --password-store-dir "$pass_dir" --gpg-home-dir "$gpg_dir" "$@"
        "$__BIN_DIR/p" --password-store-dir "$pass_dir" --gpg-home-dir "$gpg_dir" "$@"
    elif [ "x$gpg_dir" != "x" ]; then
        __v "$__BIN_DIR/p" --gpg-home-dir "$gpg_dir" "$@"
        "$__BIN_DIR/p" --gpg-home-dir "$gpg_dir" "$@"
    else
        __v "$__BIN_DIR/p" "$@"
        "$__BIN_DIR/p" "$@"
    fi
}

function gpg_start() {
    mkdir -p "$gpg_dir"

    __p gpg generate "$1" "$2" "$3"
}

function c_rm() {
    if [ -z "$DEBUG" ]; then
        rm -rf "$@"
    fi
}

function gpg_done() {
    c_rm "$gpg_dir"
}
