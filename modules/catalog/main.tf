locals {
  default_tags = {
    created-by  = "terraform"
    environment = var.env
  }
  all_tags = merge(local.default_tags, var.tags == {} ? null : var.tags)
}

resource "databricks_catalog" "catalog" {
  for_each       = { for i, c in var.catalogs : c.name => c }
  metastore_id   = var.metastore_id
  name           = "${var.env}_${each.value.name}"
  storage_root   = "${var.storage_root}/${each.value.name}"
  owner          = "groupName"
  isolation_mode = "ISOLATED"
  comment        = each.value.comment
  force_destroy  = each.value.force_destroy
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

resource "databricks_catalog" "catalog_backup" {
  for_each       = { for i, c in var.catalogs : c.name => c }
  metastore_id   = var.metastore_id
  name           = "${var.env}_${each.value.name}_backup"
  storage_root   = "${var.backup_storage_root}/${each.value.name}"
  owner          = "groupName"
  isolation_mode = "ISOLATED"
  comment        = each.value.comment
  force_destroy  = each.value.force_destroy
}

resource "databricks_grants" "catalog_grants_backup" {
  depends_on = [databricks_catalog.catalog_backup]
  for_each   = { for i, c in var.catalogs : c.name => c }
  catalog    = "${var.env}_${each.value.name}_backup"
  dynamic "grant" {
    for_each = { for i, g in each.value.grants : g.principal => g }
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }
}
