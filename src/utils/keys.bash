__p_keys_read_config() {
    local key_base="/.p/keys"
    ___p_decrypt "$key_base/config.json" -
}

__p_keys_write_config() {
    local key_base="/.p/keys"
    local contents="$(cat -)"

    if [ "x$contents" == "x" ] || [ "x${contents:0:1}" != "x{" ]; then
        __e "Invalid configuration! Refusing to save."
        return 1
    fi

    ___p_encrypt - "$key_base/config.json" <<< "$contents"
}
