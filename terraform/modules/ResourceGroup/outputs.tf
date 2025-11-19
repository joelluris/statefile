output "rg_details_output" {
  value = { for rg in azurerm_resource_group.ENV_RG : rg.name => rg.name }
}
