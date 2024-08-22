data "databricks_sql_warehouse" "sql_warehouse" {
  name = "<sqlserverless>"
}

resource "databricks_sql_table" "materialized_view" {
  for_each = { for i, v in var.materialized_views : format("%s.%s.%s", trimprefix(v.catalog_name, "${var.env}_"), v.schema_name, v.name) => v }

  name            = each.value.name
  catalog_name    = each.value.catalog_name
  schema_name     = each.value.schema_name
  table_type      = "VIEW"
  warehouse_id    = data.databricks_sql_warehouse.sql_warehouse.id
  view_definition = each.value.view_definition
  properties      = each.value.properties

  comment = each.value.comment
}