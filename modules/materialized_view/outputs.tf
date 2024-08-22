output "materialized_views" {
  description = "materialized views as a map"
  value       = tomap({ for k, v in databricks_sql_table.materialized_view : k => v.id })
}
