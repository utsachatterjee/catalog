include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_common/delta-share.hcl"
}

locals {
  environment_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env                 = local.environment_vars.locals.environment

  #Add share blocks below if you want a seperate share for each objects because you need seperate catalogs
  shares = {
    dbk1-to-dbk2 = {
      comment = "test delta share"
      owner   = "databricks-account-grp-name"
      recipient = dependency.delta-receipients.outputs.receipients["rec1"]
      objects             = [
        {
          catalog = "catalog1"
          object_names = ["all"]
          object_type = "SCHEMA"
        },
        {
          catalog = "catalog2"
          object_names = ["schemaname1","schemaname2"]
          object_type = "SCHEMA"
        }
      ]
    }
  }
}


inputs = {
  shares = local.shares
  env = local.env
}