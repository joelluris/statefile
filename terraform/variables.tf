# ==============================================================================
# COMMON VARIABLES
# ==============================================================================

variable "tenant_id" {
  description = "Azure AD Tenant ID"
  type        = string
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, stg, prd)"
  type        = string
}

# ==============================================================================
# TERRAFORM BACKEND VARIABLES
# ==============================================================================

variable "tf_storage_resource_group" {
  description = "Resource group for Terraform state storage"
  type        = string
  default     = ""
}

variable "tf_storage_account_name" {
  description = "Storage account name for Terraform state"
  type        = string
  default     = ""
}

variable "tf_container_name" {
  description = "Container name for Terraform state"
  type        = string
  default     = ""
}

variable "tf_storage_access_key" {
  description = "Access key for Terraform state storage"
  type        = string
  default     = ""
  sensitive   = true
}

# ==============================================================================
# RESOURCE GROUP MODULE VARIABLES
# ==============================================================================

variable "all_resource_groups" {
  description = "Map of resource groups to create"
  type = map(object({
    name = string
    tags = map(string)
  }))
}

# ==============================================================================
# VIRTUAL NETWORK MODULE VARIABLES
# ==============================================================================

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
  description = "Map of NSGs to create for subnets"
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

# ==============================================================================
# VNET PEERING MODULE VARIABLES
# ==============================================================================

variable "enable_vnet_peering_remote" {
  description = "Flag to enable remote VNet peering"
  type        = bool
  default     = true
}

variable "vnet_peering_remote" {
  description = "Map of VNet peering configurations"
  type = map(object({
    source_vnet_name             = string
    remote_vnet_name             = string
    resource_group_name          = string
    remote_resource_group_name   = string
    remote_environment           = string
    allow_virtual_network_access = bool
    allow_forwarded_traffic      = bool
    allow_gateway_transit        = bool
    use_remote_gateways          = bool
  }))
  default = {}
}

# ==============================================================================
# KEY VAULT MODULE VARIABLES
# ==============================================================================

variable "key_vault" {
  description = "Map of Key Vaults to create"
  type = map(object({
    kv_name    = string
    kv_rg_name = string
    sku        = string
    tags       = map(string)
  }))
}

variable "Arcon_PAM_IP" {
  description = "IP addresses for Arcon PAM access"
  type        = list(string)
  default     = []
}

variable "umbrella_ip_range" {
  description = "IP ranges for Umbrella access"
  type        = list(string)
  default     = []
}

variable "AzureDevopsrunner" {
  description = "IP addresses for Azure DevOps runners"
  type        = list(string)
  default     = []
}

# ==============================================================================
# STORAGE MODULE VARIABLES
# ==============================================================================

variable "storage_accounts" {
  description = "Map of storage accounts to create"
  type = map(object({
    resource_group_name        = string
    location                   = string
    storage_account_name       = string
    account_tier               = string
    account_replication_type   = string
    https_traffic_only_enabled = bool
    tags                       = map(string)
  }))
  default = {}
}

# ==============================================================================
# BACKUP MODULE VARIABLES
# ==============================================================================

variable "BackupVault" {
  description = "Map of Recovery Services Vaults to create"
  type = map(object({
    rsv_vault_name          = string
    location                = string
    rsv_resource_group_name = string
    rsv_vault_sku           = string
    soft_delete_enabled     = bool
    tags                    = map(string)
  }))
  default = {}
}

variable "BackupPolicy" {
  description = "Map of backup policies to create"
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
  default = {}
}

# ==============================================================================
# AZURE POLICY MODULE VARIABLES
# ==============================================================================

variable "Azure_Policy" {
  description = "Map of Azure Policy assignments"
  type = map(object({
    Name              = string
    Allowed_locations = optional(list(string))
    allowed_skus      = optional(list(string))
  }))
  default = {}
}

variable "Azure_Policy_Require_a_tag_on_rg" {
  description = "Map of required tags on resource groups"
  type = map(object({
    Name    = string
    TagName = string
  }))
  default = {}
}

# ==============================================================================
# USER ASSIGNED MANAGED IDENTITY MODULE VARIABLES
# ==============================================================================

variable "user_assigned_managed_identity" {
  description = "Map of User Assigned Managed Identities to create"
  type = map(object({
    name     = string
    rg_name  = string
    location = string
    role_assignments = map(object({
      role_definition_name = string
      scope_type           = string
      scope                = string
    }))
  }))
  default = {}
}
