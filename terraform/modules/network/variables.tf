# variable "project_code" {
#   type        = string
#   description = "The name segment for the project"
#   default     = "lnt-eip"
#   validation {
#     condition     = can(regex("^[a-z0-9-]+$", var.project_code))
#     error_message = "The name segment for the project must only contain lowercase letters, numbers and hyphens"
#   }
#   validation {
#     condition     = length(var.project_code) <= 8
#     error_message = "The name segment for the project must be 8 characters or less"
#   }
# }

# variable "environment" {
#   type        = string
#   description = "The name segment for the environment"
#   default     = "nonprod"
#   validation {
#     condition     = can(regex("^[a-z0-9]+$", var.environment))
#     error_message = "The name segment for the environment must only contain lowercase letters and numbers"
#   }
#   validation {
#     condition     = length(var.environment) <= 7
#     error_message = "The name segment for the environment must be 7 characters or less"
#   }
# }

# variable "location" {
#   type        = string
#   description = "The location/region where the resources will be created. Must be in the short form (e.g. 'uaenorth')"
#   validation {
#     condition     = can(regex("^(uaenorth)", var.location))
#     error_message = "The location must only contain lowercase letters, numbers, and hyphens and uaenorth"
#   }
#   validation {
#     condition     = length(var.location) <= 20
#     error_message = "The location must be 20 characters or less"
#   }
# }

# variable "resource_name_sequence_start" {
#   type        = number
#   description = "The number to use for the resource names"
#   default     = 1
#   validation {
#     condition     = var.resource_name_sequence_start >= 1 && var.resource_name_sequence_start <= 999
#     error_message = "The number must be between 1 and 999"
#   }
# }

# variable "resource_group_name" {
#   type        = string
#   description = "The ID of the parent virtual network, if any"
# }


# variable "tags" {
#   type        = map(string)
#   description = "Tags to apply"
# }

# variable "address_space" {
#   type        = list(string)
#   description = "The address spaces for the virtual network"
#   nullable    = false
# }

# variable "dns_servers" {
#   type = object({
#     dns_servers = list(string)
#   })
#   description = "List of DNS servers for the virtual network"
# }

# variable "name" {
#   type        = string
#   description = "The name of the virtual network"
# }


# variable "subnets" {
#   description = "Map of subnet configurations"
#   type = map(object({
#     name                            = string
#     address_prefixes                = list(string)
#     default_outbound_access_enabled = optional(bool)
#     nsg_key                         = optional(string)
#     route_table_key                 = optional(string)
#     delegation = optional(list(object({
#       name = string
#       service_delegation = optional(list(object({
#         name    = string
#         actions = optional(list(string), [])
#       })))
#     })), [])
#     service_endpoints_with_location = optional(list(object({
#       service   = string
#       locations = optional(list(string))
#     })))
#   }))
# }

# variable "network_security_group" {
#   description = "Map of network security groups with their rules"
#   type = map(object({
#     name = string
#     rules = list(object({
#       name                         = string
#       access                       = string
#       destination_address_prefix   = optional(string)
#       destination_address_prefixes = optional(list(string))
#       destination_port_range       = optional(string)
#       destination_port_ranges      = optional(list(string))
#       direction                    = string
#       priority                     = number
#       protocol                     = string
#       source_address_prefix        = optional(string)
#       source_address_prefixes      = optional(list(string))
#       source_port_range            = optional(string)
#       source_port_ranges           = optional(list(string))
#     }))
#   }))
# }

# variable "route_tables" {
#   description = "Map of route tables with their routes"
#   type = map(object({
#     name                          = string
#     disable_bgp_route_propagation = optional(bool, false)
#     routes = list(object({
#       name                   = string
#       address_prefix         = string
#       next_hop_type          = string
#       next_hop_in_ip_address = optional(string)
#     }))
#   }))
#   default = null
# }
