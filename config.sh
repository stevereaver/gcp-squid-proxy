# Project Constants
export PROJECT_ID="< PROJECT NAME >"
export TERRAFORM_STATE_BUCKET="terraform-state"

# Constants
export REGION="< REGION >"
export ZONE="< ZONE >"

# IAP web Access User List
# List the users here with either
# user:<EMAIL ADDRESS>
# domain:<DOMAIN NAME>
export IAP_USERS='["< USERS >"]'

# Terraform Mappings
export TF_VAR_project_id=${PROJECT_ID}
export TF_VAR_region=${REGION}
export TF_VAR_zone=${ZONE}
export TF_VAR_iap_users=${IAP_USERS}
