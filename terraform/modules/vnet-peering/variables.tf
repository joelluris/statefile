# ==========================================================================================
# VNet Peering Module Variables - Hub and Spoke Topology
# ==========================================================================================

variable "vnets" {
  description = "Map of VNets with IDs merged from parent module"
  type = map(object({
    name     = string
    rg_name  = string
    cidr     = list(string)
    dns      = list(string)
    tags     = map(string)
    subnets  = any
    vnet_id  = string  # Added by parent module
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
