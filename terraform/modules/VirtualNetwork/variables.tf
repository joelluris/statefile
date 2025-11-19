variable "location" {}
variable "tenant_id" {}
variable "subscription_id" {}
variable "environment" {}
variable "tf_storage_resource_group" {
  type        = string
}

variable "tf_storage_account_name" {
  type        = string
}

variable "tf_container_name" {
  type        = string
}

variable "tf_storage_access_key" {
  type        = string
  sensitive   = true
}

variable "nsg_snet" {
  description = "Map of nsg_snet to create"
  type = map(object({
    name      = string
    rg_name   = string
    vnet_name = string
    snet_name = string
    tags      = map(string)
    rules = list(object({
      name                         = string
      priority                     = number
      direction                    = string
      access                       = string
      protocol                     = string
      source_port_range            = string
      destination_port_range       = string
      destination_port_ranges      = list(string)
      source_address_prefix        = string
      destination_address_prefix   = string
      destination_address_prefixes = list(string)
    }))
  }))
}

variable "vnets" {
  description = "Map of VNets to be created"
  type = map(object({
    name    = string
    rg_name = string
    cidr    = list(string)
    dns     = list(string)
    tags    = map(string)
    subnets = map(object({
      name               = string
      cidr               = string
      service_delegation = any
    }))
  }))
}

 variable "enable_vnet_peering_remote" {
   type = bool
 }

 variable "vnet_peering_remote" {
   type = map(map(string))
 }

 variable "hub_vnet_id" {
   description = "Hub VNet ID for peering"
   type        = string
   default     = ""
 }

variable "routetables" {
  description = "Map of route tables to be created"
  type = map(object({
    name      = string
    rg_name   = string
    vnet_name = string
    snet_name = string
    tags      = map(string)
    routes = map(object({
      name             = string
      address_prefixes = list(string)
      next_hop_type    = string
      next_hop_ip      = string
    }))
  }))
}


variable "rg_details_input" {
  type = map(string)
}

variable "bgp_route_propagation_enabled" {
  description = "Flag to disable BGP route propagation"
  type        = bool
  default     = false
}
output "vnet_details_output" {
  description = "The names and IDs of all virtual networks."
  value = {
    for k, v in azurerm_virtual_network.vnets : k => {
      name = v.name
      id   = v.id
    }
  }
}

output "snet_details_output" {
  value = {
    for subnet in azurerm_subnet.subnets : "${subnet.virtual_network_name}-${subnet.name}" => {
      name = subnet.name
      id   = subnet.id
    }
  }
}
