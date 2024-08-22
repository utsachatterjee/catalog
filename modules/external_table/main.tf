data "databricks_sql_warehouse" "sql_warehouse" {
  name = "sqlwarehouse"
}

resource "databricks_sql_table" "external_table" {
  for_each = { for i, t in var.external_tables : format("%s.%s.%s", trimprefix(t.catalog_name, "${var.env}_"), t.schema_name, t.name) => t }

  name                    = each.value.name
  catalog_name            = each.value.catalog_name
  schema_name             = each.value.schema_name
  table_type              = "EXTERNAL"
  data_source_format      = each.value.data_source_format
  storage_location        = each.value.storage_location
  storage_credential_name = var.databricks_storage_credential_id
  warehouse_id            = data.databricks_sql_warehouse.sql_warehouse.id

  dynamic "column" {
    for_each = each.value.columns
    content {
      name = column.value.name
      type = column.value.type
    }
  }

  partitions = each.value.partitions
  options    = each.value.options
  properties = each.value.properties

  comment = each.value.comment
}