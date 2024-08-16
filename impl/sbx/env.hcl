# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.

locals {
  environment      = "sbx"
  databricks_workspace_url = "https://adb-222002196911544.4.azuredatabricks.net"
}
