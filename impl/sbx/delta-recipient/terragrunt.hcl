include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_common/delta-recipient.hcl"
}

locals {
  environment_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env             = local.environment_vars.locals.environment
}
# ---------------------------------------------------------------------------------------------------------------------
# Inputs of the catalogs
# ---------------------------------------------------------------------------------------------------------------------

inputs = {
  receipients = {
    ds-sbx = {
      name                = "data-services-${local.env}"
      comment             = "sandbox databricks of data-services"
      authentication_type = "DATABRICKS"
      owner               = "ar-databricks-iac-devsecops"
      permission_required = false
      grants = [
        {
          principal  = ""
          privileges = [""]
        }
      ]
    }
  }
}