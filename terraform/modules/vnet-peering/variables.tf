# ==========================================================================================
# VNet Peering Module Variables - Hub and Spoke Topology
# ==========================================================================================

variable "peering_name_spoke_to_hub" {
  description = "Name of the peering from spoke to hub"
  type        = string
}

variable "peering_name_hub_to_spoke" {
  description = "Name of the peering from hub to spoke"
  type        = string
}

variable "spoke_vnet_name" {
  description = "Name of the spoke virtual network"
  type        = string
}

variable "spoke_resource_group_name" {
  description = "Resource group name of the spoke virtual network"
  type        = string
}

variable "spoke_vnet_id" {
  description = "Resource ID of the spoke virtual network"
  type        = string
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

variable "use_remote_gateways" {
  description = "Allow spoke to use hub's VPN/ExpressRoute gateways"
  type        = bool
  default     = false
}

variable "hub_allow_gateway_transit" {
  description = "Allow hub to share its gateways with spoke"
  type        = bool
  default     = false
}
