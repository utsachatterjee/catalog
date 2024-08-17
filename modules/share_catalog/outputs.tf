output "catalogs" {
  description = "catalogs as a map"
  value       = tomap({ for k, c in databricks_catalog.catalog : k => c.name })
}