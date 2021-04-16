# Information referenced by several sub-commands; these deserve their own
# local variables. Note that we use the syntax local var="$(exec)" even
# though this clobbers the return code; we don't care about return codes
# at this stage.
local _p_version="0.1"
local _p_verbose="${VERBOSE+x}"
local _p_cwd="/"
local _p_cmd_args=()
local _p_remote_cmd_args=()

# pass-related variables
local _p_pass_path="$P_PATH"
local _p_pass_which="$(command -v pass)"
local _p_pass_url="https://www.passwordstore.org/"
local _p_pass_dir="$HOME/.password-store"
local _p_pass_gpg_dir="$HOME/.gnupg"
local _p_editor="$(command -v vi)"

# jq-related variables
local _p_jq_path="$P_JQ"
local _p_jq_which="$(command -v jq)"
local _p_jq_url="https://stedolan.github.io/jq/"

# Pass-through variables
local _p_remote_user="$P_USER"
local _p_remote_host="$P_HOST"
local _p_remote_port="$P_PORT"
local _p_remote_command="${P_CMD:-p}"

# Internal constants
local _p_key_base="/.p/keys"
