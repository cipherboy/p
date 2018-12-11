# Information referenced by several sub-commands; these deserve their own
# local variables. Note that we use the syntax local var="$(exec)" even
# though this clobbers the return code; we don't care about return codes
# at this stage.
local _p_version="0.1"
local _p_verbose="${VERBOSE+x}"
local _p_cwd="/"
local _p_remaining=()

# pass-related variables
local _p_pass_path="$P_PATH"
local _p_pass_which="$(command -v pass)"
local _p_pass_url="https://www.passwordstore.org/"
local _p_pass_dir="$HOME/.password-store"

# jq-related variables
local _p_jq_path="$P_JQ"
local _p_jq_which="$(command -v jq)"
local _p_jq_url="https://stedolan.github.io/jq/"

# These variables are used to control what functions are called; they use
# the "_pa" prefix to differentiate themselves from the above variables.
local _pc_ls="false"
local _pc_copy="false"
local _pc_cat="false"
local _pc_edit="false"
local _pc_json="false"
local _pc_mkdir="false"
local _pc_help="false"