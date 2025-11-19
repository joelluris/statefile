# Import existing route tables
import {
  to = module.VirtualNetwork.azurerm_route_table.route_tables["rt5"]
  id = "/subscriptions/43731ed3-ead8-4406-b85d-18e966dfdb9f/resourceGroups/rg-lnt-eip-aks-nonprd-uaen-01/providers/Microsoft.Network/routeTables/rt-nonprd-vm-uaen-01"
}

import {
  to = module.VirtualNetwork.azurerm_route_table.route_tables["rt4"]
  id = "/subscriptions/43731ed3-ead8-4406-b85d-18e966dfdb9f/resourceGroups/rg-lnt-eip-aks-nonprd-uaen-01/providers/Microsoft.Network/routeTables/rt-nonprd-psql-uaen-01"
}