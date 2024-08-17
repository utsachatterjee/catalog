locals {
  default_tags = {
    created-by  = "terraform"
    environment = var.env
  }
  all_tags = merge(local.default_tags, var.tags == {} ? null : var.tags)
}

resource "databricks_schema" "schema" {
  for_each      = { for i, s in var.schemas : format("%s.%s", trimprefix("${s.catalog_name}", "${var.env}_"), "${s.name}") => s }
  name          = each.value.name
  catalog_name  = each.value.catalog_name
  owner         = "ar-data-services-iac-devsecops"
  comment       = each.value.comment
  force_destroy = each.value.force_destroy
}

resource "databricks_grants" "schema_grants" {
  depends_on = [databricks_schema.schema]
  for_each   = { for i, s in var.schemas : format("%s.%s", trimprefix("${s.catalog_name}", "${var.env}_"), "${s.name}") => s }
  schema     = "${each.value.catalog_name}.${each.value.name}"
  dynamic "grant" {
    for_each = { for i, g in each.value.grants : g.principal => g }
    content {
      principal  = strcontains(lower(grant.value.principal), "deployments") || strcontains(lower(grant.value.principal), "dbx") ? "${grant.value.principal}_${var.env}" : grant.value.principal
      privileges = grant.value.privileges
    }
  }
}
