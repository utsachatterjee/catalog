locals {
  default_tags = {
    created-by  = "terraform"
    environment = var.env
  }
  all_tags = merge(local.default_tags, var.tags == {} ? null : var.tags)
}

resource "databricks_volume" "external_volumes" {
  for_each         = { for i, mv in var.external_volumes : mv.name => mv }
  name             = each.value.name
  catalog_name     = each.value.catalog_name
  schema_name      = each.value.schema_name
  volume_type      = "EXTERNAL"
  storage_location = format("%s%s", each.value.ext_location, each.value.path)
  comment          = each.value.comment
}