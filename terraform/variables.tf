# General Variables
# Define required authentication variables
variable "tenant_id" {}
variable "subscription_id" {}
//variable "client_id" {}
//variable "client_secret" {}
variable "location" {}
variable "environment" {}
variable "tf_storage_resource_group" {
  type        = string
  default     = ""  # Default to an empty string if not provided
}

variable "tf_storage_account_name" {
  type        = string
  default     = ""  # Default to an empty string if not provided
}

variable "tf_container_name" {
  type        = string
  default     = ""  # Default to an empty string if not provided
}

variable "tf_storage_access_key" {
  type        = string
  default     = ""  # Default to an empty string if not provided
  sensitive = true
}
variable "all_resource_groups" {
  type = map(object({
    name = string
    tags = map(string)
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
  default = {}
}

output "snet_details_output" {
  value = module.VirtualNetwork.snet_details_output
}

output "vnet_details_output" {
  value = module.VirtualNetwork.vnet_details_output
}

# variable "key_vault" {
#   type = map(object({
#     kv_name    = string
#     kv_rg_name = string
#     sku        = string
#     tags       = map(string)
#   }))
# }

variable "Arcon_PAM_IP" {
  type    = list(string)
  default = []
}

variable "umbrella_ip_range" {
  type    = list(string)
  default = []
}

variable "AzureDevopsrunner" {
  type    = list(string)
  default = []
}

# variable "loganalytics" {
#   type = map(object({
#     name                = string
#     resource_group_name = string
#     sku                 = string
#     tags                = map(string)
#   }))
# }

# variable "BackupVault" {
#   description = "A map of Recovery Services Vault configurations"
#   type = map(object({
#     rsv_vault_name          = string
#     location                = string
#     rsv_resource_group_name = string
#     rsv_vault_sku           = string
#     soft_delete_enabled     = bool
#     tags                    = map(string)
#   }))
# }

variable "enable_vnet_peering_remote" {
  description = "Flag to enable remote VNet peering (only for shared env)"
  type        = bool
  default     = true  # Defaulting to false ensures no peering occurs unless explicitly set
}


variable "vnet_peering_remote" {
  description = "Map of VNet peering configurations"
  type = map(object({
    source_vnet_name           = string
    remote_vnet_name           = string
    resource_group_name        = string
    remote_resource_group_name = string
    remote_environment                 = string
    allow_virtual_network_access = bool
    allow_forwarded_traffic    = bool
    allow_gateway_transit      = bool
    use_remote_gateways        = bool
  }))

   default = {}  # Set an empty map as default (null is not allowed for map type)
}

variable "BackupPolicy" {
  description = "A map of backup policy configurations"
  type = map(object({
    backup_policy_name             = string
    rsv_resource_group_name        = string
    rsv_vault_name                 = string
    timezone                       = string
    instant_restore_retention_days = number
    backup_frequency               = string
    backup_time                    = string
    retention_daily                = number
    retention_weekly               = number
    retention_weekly_days          = list(string)
    retention_monthly              = number
    retention_monthly_week         = list(string)
    retention_monthly_days         = list(string)
    retention_yearly               = number
    retention_yearly_month         = list(string)
    retention_yearly_week          = list(string)
    retention_yearly_days          = list(string)
  }))
}

variable "Azure_Policy" {
  type = map(object({
    Name              = string
    Allowed_locations = optional(list(string))
    allowed_skus      = optional(list(string))
  }))
}

variable "Azure_Policy_Require_a_tag_on_rg" {
  type = map(object({
    Name    = string
    TagName = string
  }))
  description = "Map of required tags on resource groups"
}

# variable "storage_accounts" {
#   description = "A map of storage accounts to be created"
#   type = map(object({
#     resource_group_name     = string
#     location                = string
#     storage_account_name    = string
#     account_tier            = string
#     account_replication_type = string
#     https_traffic_only_enabled = bool
#     tags                    = map(string)
#   }))
# }


