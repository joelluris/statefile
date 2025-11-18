# ============================================================================
# This variable file defines the input variables for the nonprod environment
# ============================================================================

variable "project_code" {
  type        = string
  description = "The name segment for the project"
  default     = "lnt-eip"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_code))
    error_message = "The name segment for the project must only contain lowercase letters, numbers and hyphens"
  }
  validation {
    condition     = length(var.project_code) <= 8
    error_message = "The name segment for the project must be 8 characters or less"
  }
}

variable "workloads" {
  type        = list(string)
  description = "The name segment for the workload"
  nullable    = false
  validation {
    # - Returns true only if all elements in the list evaluate to true.
    condition     = alltrue([for w in var.workloads : can(regex("^(rg|vm|aks|snet|acr|kv|api)$", w))])
    error_message = "The name segment for the workload must be one of the following: rg, vm, aks, snet, acr, kv, api"
  }
}

variable "environment" {
  type        = string
  description = "The name segment for the environment"
  default     = "nonprod"
  validation {
    condition     = can(regex("^[a-z0-9]+$", var.environment))
    error_message = "The name segment for the environment must only contain lowercase letters and numbers"
  }
  validation {
    condition     = length(var.environment) <= 7
    error_message = "The name segment for the environment must be 7 characters or less"
  }
}

variable "location" {
  type        = string
  description = "The location/region where the resources will be created. Must be in the short form (e.g. 'uaenorth')"
  validation {
    condition     = can(regex("^(uaenorth)", var.location))
    error_message = "The location must only contain lowercase letters, numbers, and hyphens and uaenorth"
  }
  validation {
    condition     = length(var.location) <= 20
    error_message = "The location must be 20 characters or less"
  }
}

variable "resource_name_sequence_start" {
  type        = number
  description = "The number to use for the resource names"
  default     = 1
  validation {
    condition     = var.resource_name_sequence_start >= 1 && var.resource_name_sequence_start <= 999
    error_message = "The number must be between 1 and 999"
  }
}

# variable "resource_name_location_short" {
#   type        = string
#   description = "The short name segment for the location"
#   default     = ""
#   validation {
#     condition     = length(var.resource_name_location_short) == 0 || can(regex("^[a-z]+$", var.resource_name_location_short))
#     error_message = "The short name segment for the location must only contain lowercase letters"
#   }
#   validation {
#     condition     = length(var.resource_name_location_short) <= 3
#     error_message = "The short name segment for the location must be 3 characters or less"
#   }
# }

# Authentication variables (appended by pipeline at runtime)
variable "tenant_id" {
  type        = string
  description = "Azure AD tenant ID for provider authentication this is being set in environment/.tfvars"
  sensitive   = true
  validation {
    condition     = var.tenant_id == "7d1a04ec-981a-405a-951b-dd2733120e4c"
    error_message = "The condition variable must be exactly '7d1a04ec-981a-405a-951b-dd2733120e4c'."
  }
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID for resource deployment (target environment) this is being set in environment/.tfvars"
  sensitive   = true
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}

# Networking variables
variable "address_space" {
  type        = list(string)
  description = "Address space for the virtual network"
}

variable "dns_servers" {
  type = object({
    dns_servers = list(string)
  })
  description = "DNS servers configuration for the virtual network"
}

# VNet 1 variables
variable "vnet1_name" {
  type        = string
  description = "Name of the first virtual network (VM VNet)"
  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9._-]{0,62}[a-zA-Z0-9_]$", var.vnet1_name))
    error_message = "VNet name must start with alphanumeric, contain only alphanumeric, underscore, hyphen, or period, and be 2-64 characters long"
  }
}

variable "vnet1_subnets" {
  description = "Map of subnet configurations for VNet 1"
  type = map(object({
    name                            = string
    address_prefixes                = list(string)
    default_outbound_access_enabled = optional(bool)
    nsg_key                         = optional(string)
    route_table_key                 = optional(string)
    delegation = optional(list(object({
      name = string
      service_delegation = list(object({
        name    = string
        actions = list(string)
      }))
    })))
    service_endpoints_with_location = optional(list(object({
      service   = string
      locations = optional(list(string))
    })))
  }))
}

variable "vnet1_nsgs" {
  description = "Map of network security groups with their rules for VNet 1"
  type = map(object({
    name = string
    rules = list(object({
      name                       = string
      access                     = string
      destination_address_prefix = string
      destination_port_range     = string
      direction                  = string
      priority                   = number
      protocol                   = string
      source_address_prefix      = string
      source_port_range          = string
    }))
  }))
}

# VNet 2 variables
variable "vnet2_name" {
  type        = string
  description = "Name of the second virtual network (AKS VNet)"
  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9._-]{0,62}[a-zA-Z0-9_]$", var.vnet2_name))
    error_message = "VNet name must start with alphanumeric, contain only alphanumeric, underscore, hyphen, or period, and be 2-64 characters long"
  }
}

variable "vnet2_subnets" {
  description = "Map of subnet configurations for VNet 2"
  type = map(object({
    name                            = string
    address_prefixes                = list(string)
    default_outbound_access_enabled = optional(bool)
    nsg_key                         = optional(string)
    route_table_key                 = optional(string)
    delegation = optional(list(object({
      name = string
      service_delegation = list(object({
        name    = string
        actions = list(string)
      }))
    })))
    service_endpoints_with_location = optional(list(object({
      service   = string
      locations = optional(list(string))
    })))
  }))
}

variable "vnet2_nsgs" {
  description = "Map of network security groups with their rules for VNet 2"
  type = map(object({
    name = string
    rules = list(object({
      name                       = string
      access                     = string
      destination_address_prefix = string
      destination_port_range     = string
      direction                  = string
      priority                   = number
      protocol                   = string
      source_address_prefix      = string
      source_port_range          = string
    }))
  }))
}

# Route Tables
variable "vnet1_route_tables" {
  description = "Map of route tables with their routes for VNet 1"
  type = map(object({
    name                          = string
    disable_bgp_route_propagation = optional(bool, false)
    routes = list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string)
    }))
  }))
  default = null
}

variable "vnet2_route_tables" {
  description = "Map of route tables with their routes for VNet 2"
  type = map(object({
    name                          = string
    disable_bgp_route_propagation = optional(bool, false)
    routes = list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string)
    }))
  }))
  default = null
}

variable "uami_names" {
  type        = map(string)
  description = "List of User Assigned Managed Identity names to create"
}

variable "aks_name" {
  type        = string
  description = "The name of the AKS cluster"
}

variable "aks_dns_prefix" {
  type        = string
  description = "DNS prefix for the AKS cluster"
}


variable "aks_node_count" {
  type        = number
  description = "The number of nodes in the AKS node pool"
  default     = 1
}

variable "aks_node_vm_size" {
  type        = string
  description = "The size of the VM for the AKS node pool"
  default     = "Standard_D2s_v3"
}

variable "aks_linux_admin_username" {
  type        = string
  description = "The admin username for the AKS Linux nodes"
  default     = "azureuser"
}

variable "admin_group_object_ids" {
  type        = list(string)
  description = "List of Azure AD group object IDs for AKS cluster administrators"
  default     = []
}

variable "acr_name" {
  type        = string
  description = "The name of the Azure Container Registry"
}

variable "node_pools" {
  type = list(object({
    name                        = string
    temporary_name_for_rotation = string
    zones                       = optional(list(number))
    vm_size                     = string
    max_count                   = number
    max_pods                    = number
    min_count                   = number
    os_disk_size_gb             = number
    os_disk_type                = string
    priority                    = string
    spot_max_price              = optional(string)
    eviction_policy             = optional(string)
    pod_subnet_id               = string
    vnet_subnet_id              = string
    node_labels                 = map(string)
    node_taints                 = list(string)
  }))
  nullable = false
}

variable "key_vault_name" {
  type        = string
  description = "The name of the Azure Key Vault"
}

variable "key_vault_key_name" {
  type        = string
  description = "The name of the Key Vault key for disk encryption"
  default     = "des-key"
}

variable "disk_encryption_set_name" {
  type        = string
  description = "The name of the disk encryption set"
}

# ==========================================================================================
# Hub VNet Configuration (for VNet Peering)
# ==========================================================================================

variable "hub_vnet_name" {
  type        = string
  description = "The name of the hub virtual network in the connectivity subscription"
}

variable "hub_vnet_resource_group_name" {
  type        = string
  description = "The resource group name of the hub virtual network"
}

# ==========================================================================================
# Windows VM Configuration
# ==========================================================================================

variable "windows_vms" {
  type = map(object({
    vm_name        = string
    vm_size        = string
    admin_username = string
    os_disk_name   = string
  }))
  description = "Map of Windows VMs to create"
}

variable "win_vm_extensions" {
  type = map(object({
    publisher            = string
    type                 = string
    type_handler_version = string
    settings             = optional(map(any))
    protected_settings   = optional(map(any))
  }))
  description = "Map of VM extensions to install on all Windows VMs"
  default     = null
}

variable "windows_vm_custom_data_script" {
  type        = string
  description = "Custom data script to run on VM first boot"
  default     = null
}

variable "win_vm" {
  type = object({
    enable_vm_extension = optional(bool, false)
    extension_command   = optional(string, "")
  })
  description = "Windows VM extension configuration"
  default = {
    enable_vm_extension = false
    extension_command   = ""
  }
}

variable "os_disk" {
  type = object({
    storage_account_type = string
    caching              = string
    disk_size_gb         = number
  })
  description = "OS disk configuration"
}

variable "data_disk" {
  type = object({
    storage_account_type = string
    disk_size_gb         = number
    caching              = string
    lun                  = number
  })
  description = "Data disk configuration for Windows VMs"
  default     = null
}

variable "win_vm_source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  description = "Source image reference for Windows VM"
}

# ==========================================================================================
# Linux VM Configuration
# ==========================================================================================

variable "linux_vms" {
  type = map(object({
    vm_name        = string
    vm_size        = string
    admin_username = string
    os_disk_name   = string
  }))
  description = "Map of Linux VMs to create"
  default     = {}
}

variable "linux_vm_extensions" {
  type = map(object({
    publisher            = string
    type                 = string
    type_handler_version = string
    settings             = optional(map(any))
    protected_settings   = optional(map(any))
  }))
  description = "Map of VM extensions to install on all Linux VMs"
  default     = null
}

variable "linux_vm_custom_data_script" {
  type        = string
  description = "Custom data script to run on Linux VM first boot"
  default     = null
}

variable "linux_vm_disable_password_authentication" {
  type        = bool
  description = "Whether to disable password authentication and use SSH keys only"
  default     = true
}

variable "linux_vm_ssh_public_key" {
  type        = string
  description = "SSH public key for Linux VM authentication"
  default     = null
}

variable "linux_os_disk" {
  type = object({
    storage_account_type = string
    caching              = string
    disk_size_gb         = number
  })
  description = "OS disk configuration for Linux VMs"
  default     = null
}

variable "linux_data_disk" {
  type = object({
    storage_account_type = string
    disk_size_gb         = number
    caching              = string
    lun                  = number
  })
  description = "Data disk configuration for Linux VMs"
  default     = null
}

variable "linux_vm_source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  description = "Source image reference for Linux VM"
  default     = null
}

