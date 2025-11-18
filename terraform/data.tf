# data "azurerm_private_dns_zone" "dns_zones" {
#   for_each = toset([
#     "privatelink.vaultcore.azure.net",
#     "privatelink.file.core.windows.net",
#     "privatelink.queue.core.windows.net",
#     "privatelink.table.core.windows.net",
#     "privatelink.uaenorth.azmk8s.io",
#     "privatelink.azurecr.io",
#     # "privatelink.postgres.azure.com", # to be enabled in LUNATE-SHARED_SERVICES
#   ])
#   provider            = azurerm.LUNATE-SHARED_SERVICES
#   name                = each.key
#   resource_group_name = "rg-app-sec-shared-uaen-01"
# }

data "azurerm_bastion_host" "central_bastion" {
  provider            = azurerm.LUNATE-SHARED_SERVICES
  name                = "bas-shared-uaen-01"
  resource_group_name = "rg-app-sec-shared-uaen-01"
}

locals {
  dns_zones_map = {
    "privatelink.vaultcore.azure.net"    = "rg-app-sec-shared-uaen-01"
    "privatelink.uaenorth.azmk8s.io"     = "rg-app-sec-shared-uaen-01"
    "privatelink.azurecr.io"             = "rg-app-sec-shared-uaen-01"
    "privatelink.blob.core.windows.net"  = "rg-net-sec-shared-uaen-01"
    "privatelink.file.core.windows.net"  = "rg-app-sec-shared-uaen-01"
    "privatelink.queue.core.windows.net" = "rg-app-sec-shared-uaen-01"
    "privatelink.table.core.windows.net" = "rg-app-sec-shared-uaen-01"
  }
}

data "azurerm_private_dns_zone" "dns_zones" {
  for_each            = local.dns_zones_map
  provider            = azurerm.LUNATE-SHARED_SERVICES
  name                = each.key
  resource_group_name = each.value
}
