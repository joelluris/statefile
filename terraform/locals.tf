locals {
  dns_zones_map = {
    "privatelink.vaultcore.azure.net"                 = "rg-hub-dns-uaenorth"
    "privatelink.uaenorth.azmk8s.io"                  = "rg-hub-dns-uaenorth"
    "privatelink.azurecr.io"                          = "rg-hub-dns-uaenorth"
    "privatelink.blob.core.windows.net"               = "rg-hub-dns-uaenorth"
    "privatelink.postgres.database.azure.com"         = "rg-hub-dns-uaenorth"
    # "privatelink.uaenorth.backup.windowsazure.com"    = "rg-hub-dns-uaenorth"
    # "privatelink.file.core.windows.net"             = "rg-hub-dns-uaenorth"
    # "privatelink.queue.core.windows.net"            = "rg-hub-dns-uaenorth"
    # "privatelink.table.core.windows.net"            = "rg-hub-dns-uaenorth"
  }
}
