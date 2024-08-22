include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_common/materialized_view.hcl"
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}
# ---------------------------------------------------------------------------------------------------------------------
# Inputs of the catalog external location
# ---------------------------------------------------------------------------------------------------------------------

inputs = {
  materialized_views = {
    "insights.postgresql.center_audit_logs_mv" = {
      name         = "center_audit_logs_mv"
      catalog_name = dependency.catalogs.outputs.catalogs["insights"]
      schema_name  = dependency.schemas.outputs.schemas["insights.postgresql"]
      view_definition = format(<<EOF
  SELECT
  --`%%m [%%p] %%q%%u@%%d (%%h) `
  to_timestamp(substring(regexp_extract(properties.message, '^([^\\[]+)', 1), 1, 23), 'yyyy-MM-dd HH:mm:ss.SSS') AS timestamp_utc,
  regexp_extract(properties.message, '\\[(\\d+)\\]', 1) AS process_id,
  regexp_extract(properties.message, '\\](.*?)\\(', 1) AS user_name,
  regexp_extract(properties.message, '@([^ ]+)', 1) AS database_name,
  regexp_extract(properties.message, '\\(([^)]+)\\)', 1) AS host_name,

  --`pgaudit fields`
  split(trim(regexp_extract(properties.message, '\\) LOG:  AUDIT: (.*)$', 1)), ',')[0] AS audit_type,
  split(trim(regexp_extract(properties.message, '\\) LOG:  AUDIT: (.*)$', 1)), ',')[1] AS statement_id,
  split(trim(regexp_extract(properties.message, '\\) LOG:  AUDIT: (.*)$', 1)), ',')[2] AS substatement_id,
  split(trim(regexp_extract(properties.message, '\\) LOG:  AUDIT: (.*)$', 1)), ',')[3] AS class,
  split(trim(regexp_extract(properties.message, '\\) LOG:  AUDIT: (.*)$', 1)), ',')[4] AS command,
  split(trim(regexp_extract(properties.message, '\\) LOG:  AUDIT: (.*)$', 1)), ',')[5] AS object_type,
  split(trim(regexp_extract(properties.message, '\\) LOG:  AUDIT: (.*)$', 1)), ',')[6] AS object_name,
  split(trim(regexp_extract(properties.message, '\\) LOG:  AUDIT: (.*)$', 1)), ',')[7] AS statement,
  split(trim(regexp_extract(properties.message, '\\) LOG:  AUDIT: (.*)$', 1)), ',')[8] AS parameter,

  --full message
  properties.message
  
FROM %s
WHERE properties.message RLIKE ' LOG:  AUDIT: ';
      EOF
      , dependency.external_tables.outputs.external_tables["insights.postgresql.center_logs"])
    }
  }
}