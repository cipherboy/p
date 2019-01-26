function __genpass() {
    local phrase_format='\w\d\d\d\d-\w\d\d\d\d-\w\d\d\d\d'
    local random_format='\c\c\c\c\c\c\c\c\c\c\c\c\c\c\c\c\c\c\c\c\c\c\c\c\c\c\c\c\c\c'

    local last_format=''
    local last_count=0

    local format=""
    local password=""

    function __genpass_special() {
        local char="$1"
        local length="$2"

        case "$char" in
            \\)
                echo '\'
                ;;
            d)
                tr -cd '[:digit:]' < /dev/urandom | fold -w $length | head -n 1
                ;;
            c)
                tr -cd '[:alnum:]' < /dev/urandom | fold -w $length | head -n 1
                ;;
            l)
                tr -cd '[:lower:]' < /dev/urandom | fold -w $length | head -n 1
                ;;
            u)
                tr -cd '[:upper:]' < /dev/urandom | fold -w $length | head -n 1
                ;;
            w)
                grep '^[a-z]*$' /usr/share/dict/words | shuf -n $length | tr -d '\n'
                ;;
            W)
                grep '^[a-z]*$' /usr/share/dict/words | shuf -n $length | tr -d '\n' | tr '[:lower:]' '[:upper:]'
                ;;
            *)
                ;;
        esac
    }

    if (( $# == 1 )); then
        if [ "x$1" == "x--phrase" ]; then
            format="$phrase_format"
        elif [ "x$1" == "x--random" ]; then
            format="$random_format"
        else
            format="$1"
        fi
    else
        format="$random_format"
    fi

    for (( index=0 ; index <= ${#format} ; index++ )); do
        local char="${format:$index:1}"
        if [ "x$char" == 'x\' ]; then
            index=$(( index + 1 ))
            char="${format:$index:1}"

            if (( last_count >= 0 )) && [ "x$char" != "x$last_format" ]; then
                password="$password$(__genpass_special "$last_format" $last_count)"
                last_format=""
                last_count=0
            fi

            last_format="$char"
            last_count=$(( last_count + 1 ))
        else
            if (( last_count >= 0 )); then
                password="$password$(__genpass_special "$last_format" $last_count)"
                last_format=""
                last_count=0
            fi

            password="$password$char"
        fi
    done

    if (( last_count >= 0 )); then
        password="$password$(__genpass_special "$last_format" $last_count)"
        last_format=""
        last_count=0
    fi

    cat - <<< "$password"
}

