include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_common/external_volume.hcl"
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

# ---------------------------------------------------------------------------------------------------------------------
# Inputs of the managed volumes
# ---------------------------------------------------------------------------------------------------------------------
inputs = {
  external_volumes = [
    {
      name         = "volumeName"
      catalog_name = dependency.catalogs.outputs.catalogs["catalogA"]
      schema_name  = dependency.schemas.outputs.schemas["catalogA.schema1"]
      ext_location = dependency.external_locations.outputs.external_location["loc1"]
      path         = "folderName"
      comment      = "this is the ovaledge_tablelist external volume"
    }
  ]

  tags = {
    resource-owner   = "Utsa Chatterjee"
    contact-info     = "utsachatterjee89@gmail.com"
  }
}
