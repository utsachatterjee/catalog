output "shares" {
  description = "receipients as a map"
  value       = tomap({ for k, c in databricks_share.dbk2dbk : k => c.name })
}