include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_common/catalog.hcl"
}

locals {
}

# ---------------------------------------------------------------------------------------------------------------------
# Inputs of the catalogs
# ---------------------------------------------------------------------------------------------------------------------

inputs = {
}
