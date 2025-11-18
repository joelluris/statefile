variable "location" {}
variable "tenant_id" {}
variable "subscription_id" {}
variable "all_resource_groups" {
  type = map(object({
    name = string
    tags = map(string)
  }))
}

output "rg_details_output" {
  value = { for rg in azurerm_resource_group.ENV_RG : rg.name => rg.name }
}
