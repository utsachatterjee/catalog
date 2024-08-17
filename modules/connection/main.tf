locals {
  default_tags = {
    created-by  = "terraform"
    environment = var.env
  }
  all_tags = merge(local.default_tags, var.tags == {} ? null : var.tags)
}

resource "databricks_connection" "connection" {
  for_each        = { for i, c in var.connections : "${var.env}_${c.name}" => c }
  name            = "${var.env}_${each.value.name}"
  connection_type = each.value.connection_type
  options         = each.value.env_vars["${var.env}"].options
  owner           = "groupName"
  properties      = each.value.env_vars["${var.env}"].properties
  comment         = each.value.env_vars["${var.env}"].comment
  lifecycle {
    ignore_changes = [options.password]
  }
}

resource "databricks_grants" "connection_grants" {
  depends_on         = [databricks_connection.connection]
  for_each           = { for i, c in var.connections : "${var.env}_${c.name}" => c }
  foreign_connection = "${var.env}_${each.value.name}"
  dynamic "grant" {
    for_each = { for i, g in each.value.env_vars["${var.env}"].grants : g.principal => g }
    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }
}
