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

variable "resource_group_name" {
  type        = string
  description = "The ID of the parent virtual network, if any"
}


variable "tags" {
  type        = map(string)
  description = "Tags to apply"
}

variable "aks_name" {
  type        = string
  description = "The name of the AKS cluster"
}

variable "aks_dns_prefix" {
  type = string
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

variable "vnet_subnet_id" {
  type        = string
  description = "The ID of the subnet to deploy the AKS cluster into"
}

variable "pod_subnet_id" {
  type        = string
  description = "The ID of the subnet to deploy the AKS pods into"
}

variable "aks_linux_admin_username" {
  type        = string
  description = "The admin username for the AKS Linux nodes"
  default     = "azureuser"
}

variable "user_assigned_identity" {
  type        = string
  description = "User Assigned Managed Identity ID for the AKS cluster control plane"
}

variable "acr_id" {
  type        = string
  description = "The ID of the Azure Container Registry to integrate with the AKS cluster"
}

variable "private_dns_zone_id" {
  type        = string
  description = "The ID of the Private DNS Zones"
}

variable "kubelet_identity_client_id" {
  type        = string
  description = "The Client ID of the User Assigned Identity for kubelet"
}

variable "kubelet_identity_object_id" {
  type        = string
  description = "The Principal/Object ID of the User Assigned Identity for kubelet"
}

variable "kubelet_identity_id" {
  type        = string
  description = "The Resource ID of the User Assigned Identity for kubelet"
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

variable "admin_group_object_ids" {
  type        = list(string)
  description = "List of Azure AD group object IDs for AKS cluster administrators"
  default     = []
}
