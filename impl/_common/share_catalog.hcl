# ---------------------------------------------------------------------------------------------------------------------
# COMMON TERRAGRUNT CONFIGURATION
# The common variables for each environment to be specified here.
# ---------------------------------------------------------------------------------------------------------------------

# Terragrunt will copy the Terraform configurations specified by the source parameter, along with any files in the
# working directory, into a temporary folder, and execute your Terraform commands in that folder. If any environment
# needs to deploy a different module version, it should redefine this block with a different ref to override the
# deployed version.
terraform {
  source = "C:/Users/utsa.chatterjee/Downloads/Repo/databricks/modules/share_catalog"
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


# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# The below can be removed if you set vnet_needed to false in an env.hcl
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
    catalogs = [
    {
      name          = "sharedCatalogA"
      provider_name = get_env("ENV") == "prd" ? "metastore1" : "metastore2"
      share_name    = get_env("ENV") == "prd" ? "share-in-prd" : "share-in-nonprod"
      comment       = "this is a share catalog."
      grants = [
        {
          principal  = "databricks-Account-grp-1"
          privileges = ["USE_CATALOG", "USE_SCHEMA", "EXECUTE", "READ_VOLUME", "SELECT", "APPLY_TAG"]
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
