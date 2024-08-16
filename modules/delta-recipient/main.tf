locals {
}

data "databricks_current_user" "current" {}

#================================================
# Create recipients
#================================================

resource "databricks_recipient" "db2db" {
  for_each = var.receipients
  name                = each.value.name
  comment             = each.value.comment
  authentication_type = each.value.authentication_type
  owner               = each.value.owner
  data_recipient_global_metastore_id = "<put your metastore-id>"
}

#================================================
# Provide permission on recipients
#================================================

resource "databricks_grants" "onrecipients" {
  for_each = {for i,k in var.receipients: i => k if k.permission_required == true }
  metastore = "<put your metastore-id>"
  dynamic "grant" {
    for_each = each.value.grants
    content {
      principal = grant.value.principal
      privileges = grant.value.privileges
    }    
  }
}