#!/bin/bash

# This code is imported from the rtypr project. Its source is at:
#
#       https://github.com/cipherboy/rtypr
#
# Please fix any rtypr bugs there and then sync here once merged.
# Thanks!
function __rtypr() {
    # Input event device to simulate events on.
    local input_device=""

    # Try to automatically detect the keyboard device. Even if all 100 input
    # events exist and aren't keyboards, this won't take that long as the
    # underling command and APIs seem fast enough.
    function __detect_input_device() {
        # 100 is an admittedly arbitrary bound.
        for index in $(seq 0 100); do
            device_path="/dev/input/event$index"

            # If the device path doesn't exist (since they are sequentially
            # numbered), we can return early.
            if [ ! -e "$device_path" ]; then
                return 1
            fi

            # We're looking for something that looks like a keyboard. Some
            # keyboards will show up multiple times, but this is a best-guess
            # effort, not science.
            if evemu-describe "$device_path" 2>/dev/null |
                    grep -q -i 'keyboard'; then
                input_device="$device_path"
                return 0
            fi
        done

        return 1
    }

    # Pause between modifier and the modified key (e.g., between shift and
    # 2 == '@').
    local modifier_pause="0.01"

    # Pause between key down and key up.
    local bounce_pause="0.005"

    # Pause between characters.
    local character_pause="0.02"

    # Pause between segments.
    local segment_pause="0.1"

    # Pause before typing begins.
    local pretype_pause="5"

    # Which shift key to use.
    local shift_key="LEFTSHIFT"

    # Whether to try to type unicode.
    local unicode="false"

    # Text to type.
    local text=()

    # Function to simulate pressing a key, given a key code as $1.
    function __key_down() {
        evemu-event "$input_device" --type EV_KEY --code "$1" --value 1 --sync
    }

    # Function to simulate releasing a key, given a key code on $1.
    function __key_up() {
        evemu-event "$input_device" --type EV_KEY --code "$1" --value 0 --sync
    }

    # Function to simulate pressing and releasing a key, given a key code on
    # $1. This handles the bounce pause to ensure that the key is registered.
    function __key_press() {
        __key_down "$1"
        sleep "$bounce_pause"
        __key_up "$1"
    }

    # Function to simulate pressing shift and a key, given a key code on $1.
    # This handles the modifier pauses at several stages. Having a modifier
    # pause before AND after ensures that the entire sequence will be
    # detected correctly when multiple shifted sequences are used in a row.
    # Otherwise, shift up from the previous sequence tends to interfere with
    # shift down from the next...
    function __key_shifted_press() {
        sleep "$modifier_pause"
        __key_down "KEY_$shift_key"
        sleep "$modifier_pause"
        __key_press "$1"
        sleep "$modifier_pause"
        __key_up "KEY_$shift_key"
        sleep "$modifier_pause"
    }

    # Complex shortcut to enable unicode typing on Linux. This is simply
    # LEFTCTRL+LEFTSHIFT+U, but with extra pauses to ensure it is detected
    # as a unit and doesn't interfere with typing the UTF32 hex code.
    function __key_unicode_shortcut() {
        sleep "$modifier_pause"
        __key_down "KEY_LEFTCTRL"
        sleep "$modifier_pause"
        __key_down "KEY_LEFTSHIFT"
        sleep "$modifier_pause"
        __key_down "KEY_U"
        sleep "$bounce_pause"
        __key_up "KEY_U"
        sleep "$modifier_pause"
        __key_up "KEY_LEFTSHIFT"
        sleep "$modifier_pause"
        __key_up "KEY_LEFTCTRL"
        sleep "$modifier_pause"
        sleep "$modifier_pause"
    }

    # Detect whether or not we can type this character as unicode. For that
    # to work, we'll have to have only a single UTF32 code point, which is 8
    # hex characters. 9 with the newline that `wc -c` helpfully counts...
    function __can_type_unicode() {
        local char="$1"
        local codepoint="$(iconv --from=utf8 --to=utf32be <<< "$char" | xxd -p | wc -c)"

        [ "$unicode" == "true" ] && (( codepoint <= 9 ))
    }

    # Type the given character as a UTF32 code point. That is done via the
    # unicode shortcut, LEFTCTRL+LEFTSHIFT+U, followed by the hex of the
    # character.
    function __type_unicode() {
        local char="$1"

        # Strip leading zeroes this time to save typing time. Most have at
        # least three leading zeroes.
        local codepoint="$(iconv --from=utf8 --to=utf32be <<< "$char" | sed 's/^0*//g' | xxd -p)"

        __key_unicode_shortcut
        __str_to_keys "$codepoint"
        __key_press "KEY_ENTER"
    }

    # Lookup table for converting a character to a keypress. Two special cases
    # not handled by generate_keycodes.py first and unicode and unknown
    # character detection at the end.
    function __char_to_keys() {
        if [ "$1" == " " ]; then
            __key_press "KEY_SPACE"
        elif [ "$1" == "	" ]; then
            __key_press "KEY_TAB"
        elif [ "$1" == "
" ]; then
            __key_press "KEY_ENTER"
        # The rest of this function is generated by generate_keycodes.py...
        # ...except for the elif and else clauses at the end.

        # Letters
        elif [ "$1" == "a" ]; then
            __key_press "KEY_A"
        elif [ "$1" == "A" ]; then
            __key_shifted_press "KEY_A"
        elif [ "$1" == "b" ]; then
            __key_press "KEY_B"
        elif [ "$1" == "B" ]; then
            __key_shifted_press "KEY_B"
        elif [ "$1" == "c" ]; then
            __key_press "KEY_C"
        elif [ "$1" == "C" ]; then
            __key_shifted_press "KEY_C"
        elif [ "$1" == "d" ]; then
            __key_press "KEY_D"
        elif [ "$1" == "D" ]; then
            __key_shifted_press "KEY_D"
        elif [ "$1" == "e" ]; then
            __key_press "KEY_E"
        elif [ "$1" == "E" ]; then
            __key_shifted_press "KEY_E"
        elif [ "$1" == "f" ]; then
            __key_press "KEY_F"
        elif [ "$1" == "F" ]; then
            __key_shifted_press "KEY_F"
        elif [ "$1" == "g" ]; then
            __key_press "KEY_G"
        elif [ "$1" == "G" ]; then
            __key_shifted_press "KEY_G"
        elif [ "$1" == "h" ]; then
            __key_press "KEY_H"
        elif [ "$1" == "H" ]; then
            __key_shifted_press "KEY_H"
        elif [ "$1" == "i" ]; then
            __key_press "KEY_I"
        elif [ "$1" == "I" ]; then
            __key_shifted_press "KEY_I"
        elif [ "$1" == "j" ]; then
            __key_press "KEY_J"
        elif [ "$1" == "J" ]; then
            __key_shifted_press "KEY_J"
        elif [ "$1" == "k" ]; then
            __key_press "KEY_K"
        elif [ "$1" == "K" ]; then
            __key_shifted_press "KEY_K"
        elif [ "$1" == "l" ]; then
            __key_press "KEY_L"
        elif [ "$1" == "L" ]; then
            __key_shifted_press "KEY_L"
        elif [ "$1" == "m" ]; then
            __key_press "KEY_M"
        elif [ "$1" == "M" ]; then
            __key_shifted_press "KEY_M"
        elif [ "$1" == "n" ]; then
            __key_press "KEY_N"
        elif [ "$1" == "N" ]; then
            __key_shifted_press "KEY_N"
        elif [ "$1" == "o" ]; then
            __key_press "KEY_O"
        elif [ "$1" == "O" ]; then
            __key_shifted_press "KEY_O"
        elif [ "$1" == "p" ]; then
            __key_press "KEY_P"
        elif [ "$1" == "P" ]; then
            __key_shifted_press "KEY_P"
        elif [ "$1" == "q" ]; then
            __key_press "KEY_Q"
        elif [ "$1" == "Q" ]; then
            __key_shifted_press "KEY_Q"
        elif [ "$1" == "r" ]; then
            __key_press "KEY_R"
        elif [ "$1" == "R" ]; then
            __key_shifted_press "KEY_R"
        elif [ "$1" == "s" ]; then
            __key_press "KEY_S"
        elif [ "$1" == "S" ]; then
            __key_shifted_press "KEY_S"
        elif [ "$1" == "t" ]; then
            __key_press "KEY_T"
        elif [ "$1" == "T" ]; then
            __key_shifted_press "KEY_T"
        elif [ "$1" == "u" ]; then
            __key_press "KEY_U"
        elif [ "$1" == "U" ]; then
            __key_shifted_press "KEY_U"
        elif [ "$1" == "v" ]; then
            __key_press "KEY_V"
        elif [ "$1" == "V" ]; then
            __key_shifted_press "KEY_V"
        elif [ "$1" == "w" ]; then
            __key_press "KEY_W"
        elif [ "$1" == "W" ]; then
            __key_shifted_press "KEY_W"
        elif [ "$1" == "x" ]; then
            __key_press "KEY_X"
        elif [ "$1" == "X" ]; then
            __key_shifted_press "KEY_X"
        elif [ "$1" == "y" ]; then
            __key_press "KEY_Y"
        elif [ "$1" == "Y" ]; then
            __key_shifted_press "KEY_Y"
        elif [ "$1" == "z" ]; then
            __key_press "KEY_Z"
        elif [ "$1" == "Z" ]; then
            __key_shifted_press "KEY_Z"

        # Number keys
        elif [ "$1" == "1" ]; then
            __key_press "KEY_1"
        elif [ "$1" == "!" ]; then
            __key_shifted_press "KEY_1"
        elif [ "$1" == "2" ]; then
            __key_press "KEY_2"
        elif [ "$1" == "@" ]; then
            __key_shifted_press "KEY_2"
        elif [ "$1" == "3" ]; then
            __key_press "KEY_3"
        elif [ "$1" == "#" ]; then
            __key_shifted_press "KEY_3"
        elif [ "$1" == "4" ]; then
            __key_press "KEY_4"
        elif [ "$1" == "$" ]; then
            __key_shifted_press "KEY_4"
        elif [ "$1" == "5" ]; then
            __key_press "KEY_5"
        elif [ "$1" == "%" ]; then
            __key_shifted_press "KEY_5"
        elif [ "$1" == "6" ]; then
            __key_press "KEY_6"
        elif [ "$1" == "^" ]; then
            __key_shifted_press "KEY_6"
        elif [ "$1" == "7" ]; then
            __key_press "KEY_7"
        elif [ "$1" == "&" ]; then
            __key_shifted_press "KEY_7"
        elif [ "$1" == "8" ]; then
            __key_press "KEY_8"
        elif [ "$1" == "*" ]; then
            __key_shifted_press "KEY_8"
        elif [ "$1" == "9" ]; then
            __key_press "KEY_9"
        elif [ "$1" == "(" ]; then
            __key_shifted_press "KEY_9"
        elif [ "$1" == "0" ]; then
            __key_press "KEY_0"
        elif [ "$1" == ")" ]; then
            __key_shifted_press "KEY_0"

        # Special characters
        elif [ "$1" == "\`" ]; then
            __key_press "KEY_GRAVE"
        elif [ "$1" == "~" ]; then
            __key_shifted_press "KEY_GRAVE"
        elif [ "$1" == "-" ]; then
            __key_press "KEY_MINUS"
        elif [ "$1" == "_" ]; then
            __key_shifted_press "KEY_MINUS"
        elif [ "$1" == "=" ]; then
            __key_press "KEY_EQUAL"
        elif [ "$1" == "+" ]; then
            __key_shifted_press "KEY_EQUAL"
        elif [ "$1" == "[" ]; then
            __key_press "KEY_LEFTBRACE"
        elif [ "$1" == "{" ]; then
            __key_shifted_press "KEY_LEFTBRACE"
        elif [ "$1" == "]" ]; then
            __key_press "KEY_RIGHTBRACE"
        elif [ "$1" == "}" ]; then
            __key_shifted_press "KEY_RIGHTBRACE"
        elif [ "$1" == "\\" ]; then
            __key_press "KEY_BACKSLASH"
        elif [ "$1" == "|" ]; then
            __key_shifted_press "KEY_BACKSLASH"
        elif [ "$1" == ";" ]; then
            __key_press "KEY_SEMICOLON"
        elif [ "$1" == ":" ]; then
            __key_shifted_press "KEY_SEMICOLON"
        elif [ "$1" == "'" ]; then
            __key_press "KEY_APOSTROPHE"
        elif [ "$1" == '"' ]; then
            __key_shifted_press "KEY_APOSTROPHE"
        elif [ "$1" == "," ]; then
            __key_press "KEY_COMMA"
        elif [ "$1" == "<" ]; then
            __key_shifted_press "KEY_COMMA"
        elif [ "$1" == "." ]; then
            __key_press "KEY_DOT"
        elif [ "$1" == ">" ]; then
            __key_shifted_press "KEY_DOT"
        elif [ "$1" == "/" ]; then
            __key_press "KEY_SLASH"
        elif [ "$1" == "?" ]; then
            __key_shifted_press "KEY_SLASH"

        # Not generated automatically
        elif __can_type_unicode "$1"; then
            __type_unicode "$1"
        else
            local hex="$(xxd -p <<< "$1")"
            local hex2="$(echo -n "$1" | xxd -p)"
            echo "Unknown key for character: [$1] hex:[$hex] hex2:[$hex2]"
        fi

        sleep "$character_pause"
    }

    # Type whole strings via iterating over each character and calling
    # __char_to_keys on it.
    function __str_to_keys() {
        local str="$1"
        for char in $(seq 1 ${#str}); do
            local key="${str:$char-1:1}"
            __char_to_keys "$key"
        done
    }

    # Type from a file or stdin. Note that this is currently treated as one
    # segment, so there is no segment pause at the end.
    function __from_file() {
        local path="$1"
        local contents=""
        if [ "x$path" != "x-" ]; then
            contents="$(cat "$path")"
        else
            contents="$(cat)"
        fi

        sleep "$pretype_pause"
        __str_to_keys "$contents"
    }

    # Type from the command line arguments. These are added to the `text`
    # global variable.
    function __from_command_line() {
        local segment_count="${#text}"

        sleep "$pretype_pause"
        for segment_index in $(seq 0 "$segment_count"); do
            local segment="${text[$segment_index]}"

            __str_to_keys "$segment"

            # The command line can handle multiple segments, but don't pause
            # after the last segment.
            if [ "$segment_index" != "$segment_count" ]; then
                sleep "$segment_pause"
            fi
        done
    }

    # Display help text.
    function __help() {
        echo "Usage: rtypr [options] [--] [<text>...]"
        echo ""
        echo "rtypr is an interface over evemu to type text. Note that this"
        echo "program frequently requires root access to operate."
        echo "Alternatively, grant the current user access to the \`input\`"
        echo "group."
        echo ""
        echo "Options:"
        echo ""
        echo "--bounce-pause, -b <sleep>: Time to sleep between pressing a"
        echo "                            key and releasing it."
        echo "                            Currently: $bounce_pause"
        echo ""
        echo "--character-pause, -c <sleep>: Time to sleep between each key"
        echo "                               event."
        echo "                               Currently: $character_pause"
        echo ""
        echo "--file, -f <file>: Read text to retype from a file."
        echo ""
        echo "--help, -h: Show this help text."
        echo ""
        echo "--input-device, -i <path>: Device to send keyboard events to."
        echo "                           Currently: $input_device"
        echo ""
        echo "--modifier-pause, -m <sleep>: Time to sleep between hitting"
        echo "                              shift and the modified key."
        echo "                              Currently: $modifier_pause"
        echo ""
        echo "--pretype-pause, -p <sleep>: Time to sleep between starting"
        echo "                             rtype and the first event."
        echo "                             Currently: $pretype_pause"
        echo ""
        echo "--segment-pause, -s <sleep>: Time to sleep between each text"
        echo "                             segment."
        echo "                             Currently: $segment_pause"
        echo ""
        echo "--shift-key, -k <key>: Name of the shift key to use."
        echo "                       Currently: $shift_key"
        echo ""
        echo "--stdin, -: Read text to retype from stdin."
        echo ""
        echo "--unicode, -u: Enable typing Unicode characters via compose"
        echo "               shortcut: LEFTCTRL+LEFTSHIFT+U."
        echo "               Currently: $unicode"
        echo ""
        echo "Note that when no input is given, this help message is printed."
    }

    # Main entry point. Parses command line arguments and types the resulting
    # text.
    function __main() {
        local show_help="false"
        local file_path=""

        while (( $# > 0 )); do
            local arg="$1"
            shift

            # We tend to be generous in what we accept as an argument...
            if [ -z "$arg" ]; then
                # This main branch could be disabled at some point. It ensures
                # that we ignore empty arguments and don't add them into the
                # global `$text`, but is a result of lazy shifting / `seq`
                # iteration. TODO: clean up argument iteration logic.
                continue
            elif [ "$arg" == "--bounce-pause" ] ||
                    [ "$arg" == "-bounce-pause" ] ||
                    [ "$arg" == "--bounce_pause" ] ||
                    [ "$arg" == "-bounce_pause" ] ||
                    [ "$arg" == "-b" ]; then
                bounce_pause="$1"
                shift
            elif [ "$arg" == "--character-pause" ] ||
                    [ "$arg" == "-character-pause" ] ||
                    [ "$arg" == "--character_pause" ] ||
                    [ "$arg" == "-character_pause" ] ||
                    [ "$arg" == "-c" ]; then
                character_pause="$1"
                shift
            elif [ "$arg" == "--file" ] ||
                    [ "$arg" == "-file" ] ||
                    [ "$arg" == "-f" ]; then
                file_path="$1"
                shift
            elif [ "$arg" == "--help" ] || [ "$arg" == "-help" ] ||
                    [ "$arg" == "-h" ]; then
                show_help="true"
            elif [ "$arg" == "--input-device" ] ||
                    [ "$arg" == "-input-device" ] ||
                    [ "$arg" == "--input_device" ] ||
                    [ "$arg" == "-input_device" ] ||
                    [ "$arg" == "-i" ]; then
                input_device="$1"
                shift
            elif [ "$arg" == "--modifier-pause" ] ||
                    [ "$arg" == "-modifier-pause" ] ||
                    [ "$arg" == "--modifier_pause" ] ||
                    [ "$arg" == "-modifier_pause" ] ||
                    [ "$arg" == "-m" ]; then
                modifier_pause="$1"
                shift
            elif [ "$arg" == "--pretype-pause" ] ||
                    [ "$arg" == "-pretype-pause" ] ||
                    [ "$arg" == "--pretype_pause" ] ||
                    [ "$arg" == "-pretype_pause" ] ||
                    [ "$arg" == "-p" ]; then
                pretype_pause="$1"
                shift
            elif [ "$arg" == "--segment-pause" ] ||
                    [ "$arg" == "-segment-pause" ] ||
                    [ "$arg" == "--segment_pause" ] ||
                    [ "$arg" == "-segment_pause" ] ||
                    [ "$arg" == "-s" ]; then
                segment_pause="$1"
                shift
            elif [ "$arg" == "--shift-key" ] ||
                    [ "$arg" == "-shift-key" ] ||
                    [ "$arg" == "--shift_key" ] ||
                    [ "$arg" == "-shift_key" ] ||
                    [ "$arg" == "-k" ]; then
                shift_key="$1"
                shift
            elif [ "$arg" == "--stdin" ] ||
                    [ "$arg" == "-stdin" ] ||
                    [ "$arg" == "-" ]; then
                file_path="-"
            elif [ "$arg" == "--unicode" ] ||
                    [ "$arg" == "-unicode" ] ||
                    [ "$arg" == "-u" ]; then
                unicode="true"
            elif [ "$arg" == "--" ]; then
                break
            else
                text+=("$arg")
            fi
        done

        # Process any remaining arguments as text...
        for arg in "$@"; do
            text+=("$arg")
        done

        # If we have no input, show the help.
        if [ "${#text}" == "0" ] && [ -z "$file_path" ]; then
            show_help="true"
        fi

        if [ -z "$input_device" ]; then
            echo "Error: empty input device. Please specify an input device." 1>&2
            echo "Note that this usually occurs when the current user lacks" 1>&2
            echo "permissions to interact with devices in /dev/input/ or" 1>&2
            echo "the evemu package is not installed. To check if you have" 1>&2
            echo "the necessary permissions, run:" 1>&2
            echo "" 1>&2
            echo "evemu-describe /dev/input/event0" 1>&2
            echo ""
            show_help="true"
        fi

        # Show help and exit.
        if [ "$show_help" == "true" ]; then
            __help
            return 0
        fi

        # Note that we can't add the pre-typing pause here, else the
        # cat from STDIN would appear to hang weirdly.
        if [ "x$file_path" != "x" ]; then
            __from_file "$file_path"
        else
            __from_command_line
        fi

        # Slight pause in case rtypr is called in quick succession.
        sleep 0.1
    }

    __detect_input_device
    __main "$@"
}
