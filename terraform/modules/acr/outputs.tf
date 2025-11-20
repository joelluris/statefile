output "acr_ids" {
  description = "Map of ACR IDs"
  value       = { for k, v in azurerm_container_registry.acr : k => v.id }
}

output "acr_login_servers" {
  description = "Map of ACR login server URLs"
  value       = { for k, v in azurerm_container_registry.acr : k => v.login_server }
}

output "acr_details" {
  description = "Complete details of all ACRs"
  value = {
    for k, v in azurerm_container_registry.acr : k => {
      id           = v.id
      name         = v.name
      login_server = v.login_server
      sku          = v.sku
    }
  }
}
