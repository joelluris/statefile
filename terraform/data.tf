data "azurerm_client_config" "current" {}

data "http" "ip" {
  url = "https://api.ipify.org/"
  retry {
    attempts     = 5
    max_delay_ms = 1000
    min_delay_ms = 500
  }
}

#checkov:skip=CKV_TF_1:Using Azure Verified Module (AVM) with semantic versioning for maintainability
# module "regions" {
#   source  = "Azure/avm-utl-regions/azurerm"
#   version = "0.5.0"
# }

data "azurerm_private_dns_zone" "dns_zones" {
  for_each = toset([
    "privatelink.vaultcore.azure.net",
    "privatelink.blob.core.windows.net",
    # "privatelink.file.core.windows.net",
    # "privatelink.queue.core.windows.net",
    # "privatelink.table.core.windows.net",
    # "privatelink.kubernetes.io",
    "privatelink.uaenorth.azmk8s.io",
    "privatelink.azurecr.io",
    # "privatelink.postgres.azure.com",
  ])
  provider            = azurerm.connectivity
  name                = each.key
  resource_group_name = "rg-hub-dns-uaenorth"
}
# Hub VNet for peering
data "azurerm_virtual_network" "hub" {
  provider            = azurerm.connectivity
  name                = var.hub_vnet_name
  resource_group_name = var.hub_vnet_resource_group_name
}
