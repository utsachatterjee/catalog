locals {
  default_tags = {
    created-by  = "terraform"
    environment = var.env
  }
  all_tags = merge(local.default_tags, var.tags == {} ? null : var.tags)
}

#==============================================================
# External location to mount data as external volumes
#==============================================================
resource "databricks_external_location" "ext_locations" {
  for_each        = var.ext_locations
  name            = "${var.env}_${each.value.name}"
  url             = lookup(each.value.url, var.env)
  owner           = "groupName"
  credential_name = var.databricks_storage_credential_id
  comment         = each.value.comment
}
#===============================================================
#Adding permissions for external loacations
#===============================================================
resource "databricks_grants" "ext_locations_grant" {
  depends_on        = [databricks_external_location.ext_locations]
  for_each          = { for i, c in var.ext_locations : c.name => c }
  external_location = "${var.env}_${each.value.name}"
  dynamic "grant" {
    for_each = { for i, g in each.value.grants : g.principal => g }
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }
}

