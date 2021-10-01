# Project Constants
export REGION=${REGION:-"australia-southeast1"}
export LOCATION="australia-southeast1"
export TERRAFORM_STATE_BUCKET="terraform-state"
export DATABASE="analysis_results"
export ENTRY_POINT="handler"
export BRANCH_NAME="main"
export ANALYSER_REPO="$PROJECT_ID-analyser"

# Analyser Constats
export STT_SUFFIX="_script.txt"
export TTS_SUFFIX="_audio.wav"
export TTS_VOICE="en-AU-Wavenet-A"
export VOICE_EXT='[".wav",".mp3"]'
export TEXT_EXT='[".txt"]'
export ERROR_MSG="File extension not supported"

# API Gateway Constats
export API_ID="analyser-web-api"
export API_GATEWAY_ID="analyser-web-api-gateway"
export API_CONFIG_ID_PREFIX="analyser-web-api-config-"
export API_YAML="apigateway_template.yaml"
export API_YAML_PATH="../artifacts/"

# GCS Constants
export INPUT_BUCKET="input_bucket"
export RESULTS_BUCKET="results_bucket"

# Function Constants
export FUNC_ANALYSER_HANDLER="analyser_handler"
export FUNC_API_HANDLER="api_handler"

# Terraform Mappings
export TF_VAR_project_id=${PROJECT_ID}
export TF_VAR_region=${REGION}
export TF_VAR_location=${LOCATION}
export TF_VAR_branch_name=${BRANCH_NAME}
export TF_VAR_analyser_repo=${ANALYSER_REPO}
export TF_VAR_input_bucket=${INPUT_BUCKET}
export TF_VAR_results_bucket=${RESULTS_BUCKET}
export TF_VAR_entry_point=${ENTRY_POINT}
export TF_VAR_func_analyser_handler=${FUNC_ANALYSER_HANDLER}
export TF_VAR_func_api_handler=${FUNC_API_HANDLER}
export TF_VAR_api_id=${API_ID}
export TF_VAR_api_gateway_id=${API_GATEWAY_ID}
export TF_VAR_api_config_id_prefix=${API_CONFIG_ID_PREFIX}
export TF_VAR_api_yaml=${API_YAML}
export TF_VAR_api_yaml_path=${API_YAML_PATH}
export TF_VAR_stt_suffix=${STT_SUFFIX}
export TF_VAR_tts_suffix=${TTS_SUFFIX}
export TF_VAR_tts_voice=${TTS_VOICE}
export TF_VAR_voice_ext=${VOICE_EXT}
export TF_VAR_text_ext=${TEXT_EXT}
export TF_VAR_error_msg=${ERROR_MSG}