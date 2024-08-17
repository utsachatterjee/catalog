locals {
  default_tags = {
    created-by  = "terraform"
    environment = var.env
  }
  all_tags = merge(local.default_tags, var.tags == {} ? null : var.tags)
}

resource "databricks_catalog" "catalog" {
  for_each        = { for i, c in var.catalogs : c.name => c }
  name            = "${var.env}_${each.value.name}"
  connection_name = each.value.connection_name
  options         = each.value.options
  owner           = "groupName"
  isolation_mode  = "ISOLATED"
  comment         = each.value.comment
  force_destroy   = each.value.force_destroy
}

resource "databricks_grants" "catalog_grants" {
  depends_on = [databricks_catalog.catalog]
  for_each   = { for i, c in var.catalogs : c.name => c }
  catalog    = "${var.env}_${each.value.name}"
  dynamic "grant" {
    for_each = { for i, g in each.value.grants : g.principal => g }
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }
}
