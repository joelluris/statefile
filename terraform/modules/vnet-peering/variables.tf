# ==========================================================================================
# VNet Peering Module Variables - Hub and Spoke Topology
# ==========================================================================================

variable "peering_configurations" {
  description = "Map of peering configurations"
  type = map(object({
    peering_name_spoke_to_hub = string
    peering_name_hub_to_spoke = string
    spoke_vnet_name           = string
    spoke_resource_group_name = string
    spoke_vnet_id             = string
    use_remote_gateways       = bool
    hub_allow_gateway_transit = bool
  }))
}

variable "hub_vnet_name" {
  description = "Name of the hub virtual network"
  type        = string
}

variable "hub_resource_group_name" {
  description = "Resource group name of the hub virtual network"
  type        = string
}

variable "hub_vnet_id" {
  description = "Resource ID of the hub virtual network"
  type        = string
}
