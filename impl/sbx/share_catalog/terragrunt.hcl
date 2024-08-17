include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_common/share_catalog.hcl"
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

# ---------------------------------------------------------------------------------------------------------------------
# Inputs of the catalogs
# ---------------------------------------------------------------------------------------------------------------------

inputs = {
}
