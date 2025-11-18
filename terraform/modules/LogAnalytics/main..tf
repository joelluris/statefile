resource "azurerm_container_registry" "acr" {
  name                          = var.acr_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = "Standard"
  admin_enabled                 = false
  # public_network_access_enabled = false
  tags                          = var.tags
}
