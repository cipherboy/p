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
local _p_pass_gpg_dir="$HOME/.gnupg"

# jq-related variables
local _p_jq_path="$P_JQ"
local _p_jq_which="$(command -v jq)"
local _p_jq_url="https://stedolan.github.io/jq/"

# These variables are used to control what functions are called; they use
# the "_pa" prefix to differentiate themselves from the above variables.
local _pc_cat="false"
local _pc_cd="false"
local _pc_clone="false"
local _pc_cp="false"
local _pc_create="false"
local _pc_locate="false"
local _pc_decrypt="false"
local _pc_edit="false"
local _pc_encrypt="false"
local _pc_find="false"
local _pc_generate="false"
local _pc_git="false"
local _pc_json="false"
local _pc_keys="false"
local _pc_mkdir="false"
local _pc_mv="false"
local _pc_open="false"
local _pc_ls="false"
local _pc_rm="false"
local _pc_search="false"
local _pc_through="false"

local _pc_help="false"
