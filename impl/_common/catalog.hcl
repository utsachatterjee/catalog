# ---------------------------------------------------------------------------------------------------------------------
# COMMON TERRAGRUNT CONFIGURATION
# The common variables for each environment to be specified here.
# ---------------------------------------------------------------------------------------------------------------------

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder. If any environment
# needs to deploy a different module version, it should redefine this block with a different ref to override the
# deployed version.
terraform {
  #source = "${get_path_to_repo_root()}/modules/catalog"  //Use this while using cloud remote backend
  source = "C:/Users/utsa.chatterjee/Downloads/Repo/databricks/modules/catalog"
}

# ---------------------------------------------------------------------------------------------------------------------
# Locals are named constants that are reusable within the configuration.
# ---------------------------------------------------------------------------------------------------------------------
locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

# ---------------------------------------------------------------------------------------------------------------------
# dependencies
# ---------------------------------------------------------------------------------------------------------------------
dependency "catalog_external_locaton" {
  config_path = "../catalog_external_locaton"
  mock_outputs = {
    storage_root        = "abfss://[user]@[host]/[path]"
    backup_storage_root = "abfss://[user]@[host]/[path]"
  }
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
  mock_outputs_merge_strategy_with_state = "shallow"
}


# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# The below can be removed if you set vnet_needed to false in an env.hcl
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  storage_root        = dependency.catalog_external_locaton.outputs.storage_root
  backup_storage_root = dependency.catalog_external_locaton.outputs.backup_storage_root
  catalogs = [
    {
      name    = "catalogA"
      comment = "temporary test catalog"
      grants = [
        {
          principal  = "databricks-Account-grp-1"                         // use group and not an user email
          privileges = ["USE_CATALOG", "USE_SCHEMA", "EXECUTE", "SELECT"] // ALL_PRIVILEGES should not be used for non admin group
        },
        {
          principal  = "databricks-Account-grp-2"
          privileges = ["<add accordingly>"]
        }
      ]
      force_destroy = false
    },
    {
      name    = "catalogB"
      comment = "temporary test catalog"
      grants = [
        {
          principal  = "databricks-Account-grp-1"
          privileges = ["USE_CATALOG", "USE_SCHEMA", "EXECUTE", "SELECT"]
        },
        {
          principal  = "databricks-Account-grp-2"
          privileges = ["<add accordingly>"]
        }
      ]
      force_destroy = false
    }
    {
      name    = "insights"
      comment = "Catalog for Azure Insights logs and metrics"
      grants = [
        {
          principal  = "GRP_DBx_data_services_developers"
          privileges = ["USE_CATALOG", "USE_SCHEMA", "EXECUTE", "CREATE_TABLE", "WRITE_VOLUME", "READ_VOLUME", "SELECT"]
        },
        {
          principal  = "GRP_data_services_deployments"
          privileges = ["USE_CATALOG", "USE_SCHEMA", "READ_VOLUME", "SELECT"]
        }
      ]
      force_destroy = false
    }
  ]

  tags = {
    resource-owner = "Utsa Chatterjee"
    contact-info   = "utsachatterjee89@gmail.com"
  }
}
