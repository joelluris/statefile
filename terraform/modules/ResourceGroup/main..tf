resource "azurerm_resource_group" "ENV_RG" {
  for_each = can(var.all_resource_groups) ? var.all_resource_groups : {}
  name     = each.value.name
  location = var.location
  tags     = each.value.tags
}
