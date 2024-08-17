include "root" {
  path = find_in_parent_folders()
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_common/connection.hcl"
}

locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

# ---------------------------------------------------------------------------------------------------------------------
# Inputs of the catalogs
# ---------------------------------------------------------------------------------------------------------------------

inputs = {
  connections = [
    {
      name            = "mysqlconnection"
      connection_type = "MYSQL"
      options = {
        host                   = "dummyserver.com"
        port                   = "3306"
        user                   = "dummyuser"
        password               = "DEFAULT"
        trustServerCertificate = true
      }
      properties = {}
      comment    = "this is a dummy server"
      grants = [
        {
          principal  = "databricks-Account-grp-1"
          privileges = ["USE_CONNECTION"]
        },
        {
          principal  = "databricks-Account-grp-2"
          privileges = ["USE_CONNECTION"]
        }
      ]
    },
    {
      name            = "sqlserverconnection"
      connection_type = "SQLSERVER"
      options = {
        host                   = "dummyserver.com"
        port                   = "1433"
        user                   = "dummyuser"
        password               = "DEFAULT"
        trustServerCertificate = true
      }
      properties = {}
      comment    = "this is a dummy server"
      grants = [
        {
          principal  = "databricks-Account-grp-1"
          privileges = ["USE_CONNECTION"]
        },
        {
          principal  = "databricks-Account-grp-2"
          privileges = ["USE_CONNECTION"]
        }
      ]
    },
    {
      name            = "postgressconnection"
      connection_type = "POSTGRESQL"
      options = {
        host                   = "dummyserver.com"
        port                   = "5432"
        user                   = "dummyuser"
        password               = "DEFAULT"
        trustServerCertificate = true
      }
      properties = {}
      comment    = "this is a dummy server"
      grants = [
        {
          principal  = "databricks-Account-grp-1"
          privileges = ["USE_CONNECTION"]
        },
        {
          principal  = "databricks-Account-grp-2"
          privileges = ["USE_CONNECTION"]
        }
      ]
    } 
  ]

  tags = {
    resource-owner   = "Utsa Chatterjee"
    contact-info     = "utsachatterjee89@gmail.com"
  }
}
