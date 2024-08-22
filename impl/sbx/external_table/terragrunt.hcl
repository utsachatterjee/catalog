include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_common/external_table.hcl"
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}
# ---------------------------------------------------------------------------------------------------------------------
# Inputs of the catalog external location
# ---------------------------------------------------------------------------------------------------------------------

inputs = {
  external_tables = {
    "insights.postgresql.center_logs" = {
      name               = "center_logs"
      catalog_name       = dependency.catalogs.outputs.catalogs["insights"]
      schema_name        = dependency.schemas.outputs.schemas["insights.postgresql"]
      data_source_format = "JSON"
      storage_location   = dependency.external_locations.outputs.nonuc_external_location["postgresqllogs"]
      columns = [{
        name = "time"
        type = "STRING"
        },
        {
          name = "properties"
          type = "STRUCT<timestamp: STRING, processId: INTEGER, errorLevel: STRING, sqlerrcode: STRING, message: STRING>"
        },
        {
          name = "resourceId"
          type = "STRING"
        },
        {
          name = "location"
          type = "STRING"
        },
        {
          name = "category"
          type = "STRING"
        },
        {
          name = "operationName"
          type = "STRING"
      }]
      partitions = ["year integer", "month integer", "day integer", "hour integer", "minute integer"]
    }
  }
}
