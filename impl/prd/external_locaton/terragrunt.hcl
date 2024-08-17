include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_common/external_location.hcl"
}

locals {
  # Automatically load environment-level variables
}
# ---------------------------------------------------------------------------------------------------------------------
# Inputs of the catalog external location
# ---------------------------------------------------------------------------------------------------------------------

inputs = {
  ext_locations = {
    loc1 = {
      name = "loc1"
      url = "abfss://<container1>@<storageaccountname>.dfs.core.windows.net/"
      comment = "this is a test location"
      grants = [
        {
          principal  = "databricks-Account-grp-1"
          privileges = ["READ_FILES", "CREATE_EXTERNAL_VOLUME", "CREATE_EXTERNAL_TABLE"]
        }
      ]
    },
    loc2 = {
      name = "loc2"
      url = "abfss://<container2>@<storageaccountname>.dfs.core.windows.net/"
      comment = "this is a test location"
      grants = [
        {
          principal  = "databricks-Account-grp-1"
          privileges = ["READ_FILES", "WRITE_FILES", "CREATE_EXTERNAL_VOLUME", "CREATE_EXTERNAL_TABLE"]
        }
      ]
    }
  }

  tags = {
    resource-owner   = "Utsa Chatterjee"
    contact-info     = "utsachatterjee89@gmail.com"
  }
}
