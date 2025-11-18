variable "storage_accounts" {
  description = "A map of storage accounts to be created"
  type = map(object({
    resource_group_name     = string
    location                = string
    storage_account_name    = string
    account_tier            = string
    account_replication_type = string
    https_traffic_only_enabled = bool
    tags                    = map(string)
  }))
}
variable "environment" {}
variable "snet_details_output" {
  type = map(object({
    id = string
  }))
}
