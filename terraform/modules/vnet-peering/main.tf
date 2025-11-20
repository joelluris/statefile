# ==========================================================================================
# VNet Peering Module - Hub and Spoke Topology
# - Creates peering from spoke VNet to hub VNet (in spoke subscription)
# - Creates peering from hub VNet to spoke VNet (in hub/connectivity subscription)
# ==========================================================================================

# Peering from spoke to hub (created in spoke subscription)
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  for_each                  = var.peering_configurations
  name                      = each.value.peering_name_spoke_to_hub
  resource_group_name       = each.value.spoke_resource_group_name
  virtual_network_name      = each.value.spoke_vnet_name
  remote_virtual_network_id = var.hub_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = each.value.use_remote_gateways
}

# Peering from hub to spoke (created in hub/connectivity subscription)
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  for_each                  = var.peering_configurations
  provider                  = azurerm.connectivity
  name                      = each.value.peering_name_hub_to_spoke
  resource_group_name       = var.hub_resource_group_name
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = each.value.spoke_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = each.value.hub_allow_gateway_transit
  use_remote_gateways          = false
}
