resource "azurerm_user_assigned_identity" "uami" {
  for_each = var.uami_names

  name                = each.value
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}
