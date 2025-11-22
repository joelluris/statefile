variable "aks" {
  description = "Map of AKS clusters to create"
  type = map(object({
    name                                = string
    resource_group_name                 = string
    location                            = string
    dns_prefix                          = string
    sku_tier                            = string
    private_cluster_enabled             = bool
    private_cluster_public_fqdn_enabled = bool
    azure_policy_enabled                = bool
    only_critical_addons_enabled        = bool
    node_vm_size                        = string
    node_os_disk_size_gb                = number
    auto_scaling_enabled                = bool
    aks_node_count                      = number
    max_pods                            = number
    enable_azure_ad                     = bool
    tags                                = map(string)
    node_pools = map(object({
      name                        = string
      temporary_name_for_rotation = string
      zones                       = list(number)
      vm_size                     = string
      max_count                   = number
      max_pods                    = number
      min_count                   = number
      os_disk_size_gb             = number
      os_disk_type                = string
      priority                    = string
      spot_max_price              = string
      eviction_policy             = string
      vnet_subnet_id              = string
      node_labels                 = map(string)
      node_taints                 = list(string)
      tags                        = map(string)
    }))
  }))
}

variable "vnet_subnet_id" {
  type        = string
  description = "The subnet ID for the AKS default node pool"
}

variable "subnet_ids" {
  type        = map(string)
  description = "Map of subnet IDs for node pools"
}

variable "private_dns_zone_id" {
  type        = string
  description = "The private DNS zone ID for the AKS private cluster"
}

variable "user_assigned_identity_ids" {
  type        = map(string)
  description = "Map of User Assigned Managed Identity IDs for AKS control planes"
}

variable "admin_group_object_ids" {
  type        = list(string)
  description = "List of Azure AD group object IDs for AKS cluster administrators"
  default     = []
}

variable "kubelet_identity_details" {
  type = map(object({
    id           = string
    client_id    = string
    principal_id = string
  }))
  description = "Map of User Assigned Managed Identity details for AKS kubelet identities"
}
