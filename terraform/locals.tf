locals {
  dns_zones_map = {
    "vaultcore" = "privatelink.vaultcore.azure.net"
    "blob"      = "privatelink.blob.core.windows.net"
    "acr"       = "privatelink.azurecr.io"
  }

  dns_zones_rg_map = {
    "vaultcore" = "rg-hub-dns-uaenorth"
    "blob"      = "rg-hub-dns-uaenorth"
    "acr"       = "rg-hub-dns-uaenorth"
  }
}