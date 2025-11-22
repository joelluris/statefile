# locals {
#   dns_zones_map = {
#     "privatelink.vaultcore.azure.net"    = "rg-app-sec-shared-uaen-01"
#     "privatelink.uaenorth.azmk8s.io"     = "rg-app-sec-shared-uaen-01"
#     "privatelink.azurecr.io"             = "rg-app-sec-shared-uaen-01"
#     "privatelink.blob.core.windows.net"  = "rg-net-sec-shared-uaen-01"
#     "privatelink.file.core.windows.net"  = "rg-app-sec-shared-uaen-01"
#     "privatelink.queue.core.windows.net" = "rg-app-sec-shared-uaen-01"
#     "privatelink.table.core.windows.net" = "rg-app-sec-shared-uaen-01"
#   }
# }

# data "azurerm_private_dns_zone" "dns_zones" {
#   for_each            = local.dns_zones_map
#   provider            = azurerm.LUNATE-SHARED_SERVICES
#   name                = each.key
#   resource_group_name = each.value
# }

# data "azurerm_virtual_network" "hub" {
#   provider            = azurerm.LUNATE-SHARED_SERVICES
#   name                = "vnet-hub-uaen-01"
#   resource_group_name = "rg-net-sec-shared-uaen-01"
# }

# =====================================================================================

data "azurerm_private_dns_zone" "dns_zones" {
  for_each            = local.dns_zones_map
  provider            = azurerm.connectivity
  name                = each.value
  resource_group_name = local.dns_zones_rg_map[each.key]
}

# This is needed for VNet peering configurations
data "azurerm_virtual_network" "hub" {
  provider            = azurerm.connectivity
  name                = "vnet-hub-uaenorth"
  resource_group_name = "rg-hub-uaenorth"
}

data "azurerm_log_analytics_workspace" "la_workspace" {
  provider            = azurerm.management
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_resource_group_name
}
