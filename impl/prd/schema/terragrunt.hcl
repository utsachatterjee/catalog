include "root" {
  path = find_in_parent_folders()
}
include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_common/schema.hcl"
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

# ---------------------------------------------------------------------------------------------------------------------
# Inputs of the Schema
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  schemas = [
    {
      name         = "schema1"
      catalog_name = dependency.catalogs.outputs.catalogs["catalogA"]
      comment      = "this is schema"
      grants = [
        {
          principal  = "databricks-Account-grp-1"                                                   
          privileges = ["USE_SCHEMA", "EXECUTE", "SELECT", "READ_VOLUME", "WRITE_VOLUME", "CREATE_TABLE"]
        }
      ]
      force_destroy = false
    },
    {
      name         = "schema2"
      catalog_name = dependency.catalogs.outputs.catalogs["catalogA"]
      comment      = "this is schema"
      grants = [
        {
          principal  = "databricks-Account-grp-2"                                                   
          privileges = ["USE_SCHEMA", "EXECUTE", "SELECT", "READ_VOLUME", "WRITE_VOLUME", "CREATE_TABLE"]
        }
      ]
      force_destroy = false
    },
    {
      name         = "schema3"
      catalog_name = dependency.catalogs.outputs.catalogs["catalogB"]
      comment      = "this is schema"
      grants = [
        {
          principal  = "databricks-Account-grp-1"                                                    
          privileges = ["USE_SCHEMA", "EXECUTE", "SELECT", "READ_VOLUME", "WRITE_VOLUME", "CREATE_TABLE"]
        }
      ]
      force_destroy = false
    }
    {
      name         = "postgresql"
      catalog_name = dependency.catalogs.outputs.catalogs["insights"]
      comment      = "Schema for postgresql Azure Insights logs and metrics"
      grants = [
        {
          principal  = "GRP_data_services_deployments"                                                    // must be a group and not an user email
          privileges = ["USE_SCHEMA", "EXECUTE", "SELECT", "READ_VOLUME", "WRITE_VOLUME", "CREATE_TABLE"] // ALL_PRIVILEGES is not allowed
        },
        {
          principal  = "GRP_DBx_data_services_developers"
          privileges = ["USE_SCHEMA", "SELECT", "READ_VOLUME"] // ALL_PRIVILEGES is not allowed
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
