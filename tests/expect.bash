export __CUR_DIR="$(dirname "${BASH_SOURCE[0]}")"
export __BIN_DIR="$__CUR_DIR/../bin"

source "$__CUR_DIR/common.bash"

export t_expect_success=0
export t_expect_total=0

function t_expect_dir() {
    t_expect_total=$((t_expect_total += 1))
    if [ ! -d "$1" ]; then
        __e "Expected \`$1\` to be a directory."
        exit 1
    fi
    t_expect_success=$((t_expect_success += 1))
}

function t_expect_file() {
    t_expect_total=$((t_expect_total += 1))
    if [ ! -e "$1" ]; then
        __e "Expected \`$1\` to be a file."
        exit 1
    fi
    t_expect_success=$((t_expect_success += 1))
}

function t_expect_not_exist() {
    t_expect_total=$((t_expect_total += 1))
    if [ -e "$1" ]; then
        __e "Expected \`$1\` to not exist."
        exit 1
    fi
    t_expect_success=$((t_expect_success += 1))
}

function t_expect_string_in_file() {
    t_expect_total=$((t_expect_total += 1))
    grep -q -F "$2" "$1"
    local ret=$?
    if (( ret != 0 )); then
        __e "Expected \`$2\` to be in \`$1\`."
        exit 1
    fi
    t_expect_success=$((t_expect_success += 1))
}

function t_expect_line_in_file() {
    t_expect_total=$((t_expect_total += 1))
    grep -q -F "^$2$" "$1"
    local ret=$?
    if (( ret != 0 )); then
        __e "Expected \`$2\` to be a line in \`$1\`."
        exit 1
    fi
    t_expect_success=$((t_expect_success += 1))
}

function t_expect_done() {
    echo "[[ expectations: $t_expect_success / $t_expect_total ]]"
}
