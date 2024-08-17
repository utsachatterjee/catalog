include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_common/foreign_catalog.hcl"
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env              = local.environment_vars.locals.environment
}

# ---------------------------------------------------------------------------------------------------------------------
# Inputs of the catalogs
# ---------------------------------------------------------------------------------------------------------------------

inputs = {
  catalogs = [
    {
      name            = "foreignCatalogA"
      connection_name = dependency.connection.outputs.connections["${local.env}_mysqlconnection"]
      options         = {
        database = "databaseName"
      }
      comment = "this is foreign catalog."
      grants = [
        {
          principal  = "databricks-Account-grp-1"
          privileges = ["USE_CATALOG", "USE_SCHEMA", "SELECT", "APPLY_TAG"]
        }
      ]
      force_destroy = false
    },
    {
      name            = "foreignCatalogB"
      connection_name = dependency.connection.outputs.connections["${local.env}_sqlserverconnection"]
      options = {
        database = "databaseName"
      }
      comment = "this is the aims3 foreign catalog."
      grants = [
        {
          principal  = "databricks-Account-grp-1"
          privileges = ["USE_CATALOG", "USE_SCHEMA", "SELECT", "APPLY_TAG"]
        }
      ]
      force_destroy = false
    },
    {
      name            = "foreignCatalogC"
      connection_name = dependency.connection.outputs.connections["${local.env}_postgressconnection"]
      options = {
        database = "databaseName"
      }
      comment = "this is foreign catalog."
      grants = [
        {
          principal  = "databricks-Account-grp-1"
          privileges = ["USE_CATALOG", "USE_SCHEMA", "SELECT", "APPLY_TAG"]
        }
      ]
      force_destroy = false
    }
  ]

  tags = {
    resource-owner   = "Utsa Chatterjee"
    contact-info     = "utsachatterjee89@gmail.com"
  }
}
