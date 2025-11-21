resource "azuread_group" "azure_network_admins" {
  display_name     = "RoleGroup-Azure-Network-Administrator"
  security_enabled = true
}

resource "azuread_group" "azure_security_admins" {
  display_name     = "RoleGroup-Azure-Security-Administrator"
  security_enabled = true
}

output "azure_network_admins_id" {
  value = azuread_group.azure_network_admins.id
}

output "azure_security_admins_id" {
  value = azuread_group.azure_security_admins.id
}

resource "azurerm_role_assignment" "network_admin" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Network Contributor"
  principal_id         = azuread_group.azure_network_admins.object_id
}

resource "azurerm_role_assignment" "security_admin" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Security Admin"
  principal_id         = azuread_group.azure_security_admins.object_id
}
