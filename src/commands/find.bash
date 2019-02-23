function ___p_find() {
    if (( $# == 0 )); then
        find "$_p_pass_dir" -name '.git' -prune -o -print | sed '/\/\.gpg-id$/d' | sed 's,\.gpg$,,g' | sed "s,^${_p_pass_dir}[/],,g"  | tail -n +2
    else
        find "$_p_pass_dir" -name '.git' -prune -o "$@" -print | sed '/\/\.gpg-id$/d' | sed 's,\.gpg$,,g' | sed "s,^${_p_pass_dir}[/]*,,g"
    fi
}
