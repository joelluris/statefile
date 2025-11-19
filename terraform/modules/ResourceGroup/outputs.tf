output "rg_details_output" {
  value = { for rg in azurerm_resource_group.ENV_RG : rg.name => rg.name }
}

output "rg_ids" {
  value = { for k, rg in azurerm_resource_group.ENV_RG : k => rg.id }
}