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
  multishares = {
    csp_to_DA_btw = {
      comment = "btw CSP-DA migartion"
      owner   = "ar-databricks-iac-devsecops"
      recipient = ["data-services-${local.env}"]
      objects             = [
        {
          catalog = "alearn"
          object_names = ["all"]
          object_type = "SCHEMA"
        },
        {
          catalog = "clintrax"
          object_names = ["all"]
          object_type = "SCHEMA"
        },
        {
          catalog = "cms_openpayments"
          object_names = ["clean"]
          object_type = "SCHEMA"
        },
        {
          catalog = "epharmasolutions"
          object_names = ["clean"]
          object_type = "SCHEMA"
        },
        {
          catalog = "entity_resolution"
          object_names = ["all"]
          object_type = "SCHEMA"
        },
        {
          catalog = "grn"
          object_names = ["all"]
          object_type = "SCHEMA"
        },
        {
          catalog = "iris"
          object_names = ["all"]
          object_type = "SCHEMA"
        },
        {
          catalog = "lookup_datasets"
          object_names = ["all"]
          object_type = "SCHEMA"
        },
        {
          catalog = "pharmaseek"
          object_names = ["all"]
          object_type = "SCHEMA"
        },
        {
          catalog = "medavante_prophase"
          object_names = ["clean"]
          object_type = "SCHEMA"
        },
        {
          catalog = "netsuite"
          object_names = ["all"]
          object_type = "SCHEMA"
        },
        {
          catalog = "salesforce"
          object_names = ["all"]
          object_type = "SCHEMA"
        },
        {
          catalog = "study_coordinator"
          object_names = ["all"]
          object_type = "SCHEMA"
        },
        {
          catalog = "synthetic_indications"
          object_names = ["all"]
          object_type = "SCHEMA"
        },
        {
          catalog = "tamr"
          object_names = ["all"]
          object_type = "SCHEMA"
        },
        {
          catalog = "threewire"
          object_names = ["all"]
          object_type = "SCHEMA"
        },
        {
          catalog = "trifecta"
          object_names = ["all"]
          object_type = "SCHEMA"
        }
      ]
    }
  }
}


inputs = {
  multishares = local.multishares
  env = local.env
}