locals {
  default_tags = {
    created-by  = "terraform"
    environment = var.env
  }
  all_tags = merge(local.default_tags, var.tags == {} ? null : var.tags)
}

resource "databricks_volume" "managed_volume" {
  for_each     = { for i, mv in var.managed_volumes : mv.name => mv }
  name         = each.value.name
  catalog_name = each.value.catalog_name
  schema_name  = each.value.schema_name
  volume_type  = "MANAGED"
  comment      = each.value.comment
}

resource "databricks_volume" "managed_volume_backup" {
  for_each     = { for i, mv in var.managed_volumes : mv.name => mv }
  name         = each.value.name
  catalog_name = "${each.value.catalog_name}_backup"
  schema_name  = each.value.schema_name
  volume_type  = "MANAGED"
  comment      = each.value.comment
}
