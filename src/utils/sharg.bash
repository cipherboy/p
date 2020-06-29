function _handle_parse_error {
  _p_print_help
  echo 1>&2
  echo "Unknown value for argument $1: $2" 1>&2
  exit 1
}
