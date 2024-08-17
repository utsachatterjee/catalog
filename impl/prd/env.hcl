# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.

locals {
  environment      = "sbx"
  databricks_workspace_url = "<put your databricks url>"
}
