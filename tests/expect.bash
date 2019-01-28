function t_dir() {
    local dir="$(mktemp -d)"
    local user="$(id --user)"
    local group="$(id --group)"

    chown -R "$user:$group" "$dir"
    chmod -R 700 "$dir"

    echo "$dir"
}

function __e() {
    echo "e:" "$@" 1>&2
}

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

function t_expect_stats() {
    echo "[[ expectations: $t_expect_success / $t_expect_total ]]"
}
