# ==========================================================================================
# Main Terraform Configuration
# - Module definitions: Compose infrastructure from reusable modules
# - Data sources: Reference existing resources (e.g., Private DNS zones from hub subscription)
# - Resource orchestration: Define dependencies and pass outputs between modules
# ==========================================================================================

resource "random_string" "unique_name" {
  length  = 3
  special = false
  upper   = false
  numeric = false
}

#=======================
#Resource Groups Module
#=======================

module "resource_group" {
  source = "./modules/rg"

  project_code                 = var.project_code
  environment                  = var.environment
  location                     = var.location
  workloads                    = var.workloads
  tags                         = var.tags
  resource_name_sequence_start = var.resource_name_sequence_start
}

#== Azure Networking Module - VNet 1 (VM) ==#
module "vnet1" {
  source = "./modules/network"

  providers = {
    azurerm.connectivity = azurerm.connectivity
    azurerm              = azurerm
  }

  location                     = var.location
  tags                         = var.tags
  resource_name_sequence_start = var.resource_name_sequence_start
  resource_group_name          = module.resource_group.resource_group_names["vm"]

  address_space          = [var.address_space[0]]
  dns_servers            = var.dns_servers
  name                   = var.vnet1_name
  subnets                = var.vnet1_subnets
  network_security_group = var.vnet1_nsgs
  route_tables           = var.vnet1_route_tables
}

#========================================
# Azure Networking Module - VNet 2 (AKS)
#========================================
module "vnet2" {
  source = "./modules/network"

  providers = {
    azurerm.connectivity = azurerm.connectivity
    azurerm              = azurerm
  }

  location                     = var.location
  tags                         = var.tags
  resource_name_sequence_start = var.resource_name_sequence_start
  resource_group_name          = module.resource_group.resource_group_names["aks"]

  address_space          = [var.address_space[1]]
  dns_servers            = var.dns_servers
  name                   = var.vnet2_name
  subnets                = var.vnet2_subnets
  network_security_group = var.vnet2_nsgs
  route_tables           = var.vnet2_route_tables
}

#=========================================
# User Assigned Managed Identities Module
#=========================================
module "user_assigned_managed_identity" {
  source = "./modules/uami"

  uami_names          = var.uami_names
  location            = var.location
  resource_group_name = module.resource_group.resource_group_names["aks"]
  tags                = var.tags

  depends_on = [module.resource_group]
}

#=================================
# Azure Container Registry Module
#=================================
module "acr" {
  source = "./modules/acr"

  acr_name            = var.acr_name
  location            = var.location
  resource_group_name = module.resource_group.resource_group_names["aks"]
  tags                = var.tags
  private_dns_zone_id = data.azurerm_private_dns_zone.dns_zones["privatelink.azurecr.io"].id
}

#=========================
# Role Assignments Module
#=========================
module "role_assignments" {
  source = "./modules/role-assignment"

  role_assignments = [
    # The AKS control plane ("kubernetes" identity) needs the Managed Identity Operator role on the kubelet identity.
    # This allows the control plane to assign the kubelet identity to node pools (VMSS) during cluster operations.
    # Without this, AKS cannot attach the kubelet identity to nodes, and cluster creation or scaling will fail.
    # See: https://learn.microsoft.com/en-us/azure/aks/managed-identity-overview
    {
      name                 = "kubernetes_contributor"
      principal_id         = module.user_assigned_managed_identity.principal_ids["kubernetes"]
      role_definition_name = "Contributor"
      scope                = module.resource_group.resource_group_ids["aks"]
    },
    # Managed Identity Operator role for Kubernetes UAMI to manage Kubelet UAMI because 
    {
      name                 = "kubernetes_managed_identity_operator"
      principal_id         = module.user_assigned_managed_identity.principal_ids["kubernetes"]
      role_definition_name = "Managed Identity Operator"
      scope                = module.user_assigned_managed_identity.resource_ids["kubelet"]
    },
    {
      name                 = "kubelet_acrpull"
      principal_id         = module.user_assigned_managed_identity.principal_ids["kubelet"]
      role_definition_name = "AcrPull"
      scope                = module.acr.acr_id
    },
    # Private DNS Zone Contributor for AKS to manage DNS records
    {
      name                 = "kubernetes_private_dns_zone_contributor"
      principal_id         = module.user_assigned_managed_identity.principal_ids["kubernetes"]
      role_definition_name = "Private DNS Zone Contributor"
      scope                = data.azurerm_private_dns_zone.dns_zones["privatelink.uaenorth.azmk8s.io"].id
    },
    {
      name                 = "workload_acrpush"
      principal_id         = module.user_assigned_managed_identity.principal_ids["workload"]
      role_definition_name = "AcrPush"
      scope                = module.acr.acr_id
    },
    {
      name                 = "workload_acrdelete"
      principal_id         = module.user_assigned_managed_identity.principal_ids["workload"]
      role_definition_name = "AcrDelete"
      scope                = module.acr.acr_id
    },
    {
      name                 = "workload_key_vault_secret_user"
      principal_id         = module.user_assigned_managed_identity.principal_ids["workload"]
      role_definition_name = "Key Vault Secrets User"
      scope                = module.key_vault.key_vault_id
    },
  ]

  depends_on = [
    module.user_assigned_managed_identity,
    module.acr,
    module.resource_group
  ]
}

#============
# AKS Module
#============
module "aks" {
  source = "./modules/aks"

  aks_name            = var.aks_name
  location            = var.location
  resource_group_name = module.resource_group.resource_group_names["aks"] 
  tags                = var.tags

  aks_dns_prefix           = var.aks_dns_prefix
  aks_node_count           = var.aks_node_count
  aks_node_vm_size         = var.aks_node_vm_size
  vnet_subnet_id           = module.vnet2.subnet_ids["aks"]
  pod_subnet_id            = module.vnet2.subnet_ids["pod"]
  aks_linux_admin_username = var.aks_linux_admin_username
  admin_group_object_ids   = var.admin_group_object_ids
  acr_id                   = module.acr.acr_id
  private_dns_zone_id      = data.azurerm_private_dns_zone.dns_zones["privatelink.uaenorth.azmk8s.io"].id
  user_assigned_identity   = module.user_assigned_managed_identity.resource_ids["kubernetes"]

  # Kubelet identity properties
  kubelet_identity_client_id = module.user_assigned_managed_identity.client_ids["kubelet"]
  kubelet_identity_object_id = module.user_assigned_managed_identity.principal_ids["kubelet"]
  kubelet_identity_id        = module.user_assigned_managed_identity.resource_ids["kubelet"]

  # Transform node_pools to resolve subnet keys to actual subnet IDs
  node_pools = [
    for pool in var.node_pools : {
      name                        = pool.name
      temporary_name_for_rotation = pool.temporary_name_for_rotation
      zones                       = pool.zones
      vm_size                     = pool.vm_size
      max_count                   = pool.max_count
      max_pods                    = pool.max_pods
      min_count                   = pool.min_count
      os_disk_size_gb             = pool.os_disk_size_gb
      os_disk_type                = pool.os_disk_type
      priority                    = pool.priority
      spot_max_price              = pool.spot_max_price
      eviction_policy             = pool.eviction_policy
      vnet_subnet_id              = module.vnet2.subnet_ids[pool.vnet_subnet_id]
      pod_subnet_id               = module.vnet2.subnet_ids[pool.pod_subnet_id]
      node_labels                 = pool.node_labels
      node_taints                 = pool.node_taints
    }
  ]

  depends_on = [
    module.vnet2,
    module.user_assigned_managed_identity,
    module.role_assignments,
  ]
}

#==================
# Key Vault Module
#==================
module "key_vault" {
  source = "./modules/key-vault"

  key_vault_name           = var.key_vault_name
  location                 = var.location
  resource_group_name      = module.resource_group.resource_group_names["vm"]
  tags                     = var.tags
  subnet_ids               = [module.vnet1.subnet_ids["vm"]]
  private_dns_zone_id      = data.azurerm_private_dns_zone.dns_zones["privatelink.vaultcore.azure.net"].id
  key_vault_key_name       = var.key_vault_key_name
  disk_encryption_set_name = var.disk_encryption_set_name

  depends_on = [
    module.vnet1,
    module.resource_group
  ]
}

#===================
# Windows VM Module
#===================
module "windows_vm" {
  source = "./modules/windows-vm"

  windows_vms            = var.windows_vms
  location               = var.location
  resource_group_name    = module.resource_group.resource_group_names["vm"]
  tags                   = var.tags
  subnet_id              = module.vnet1.subnet_ids["vm"]
  key_vault_id           = module.key_vault.key_vault_id
  custom_data_script     = var.windows_vm_custom_data_script
  disk_encryption_set_id = module.key_vault.disk_encryption_set_id

  source_image_reference = var.win_vm_source_image_reference
  os_disk                = var.os_disk
  data_disk              = var.data_disk
  win_vm                 = var.win_vm
  extensions             = var.win_vm_extensions

  depends_on = [
    module.vnet1,
    module.key_vault,
    module.resource_group
  ]
}

#=================
# Linux VM Module
#=================
# module "linux_vm" {
#   source = "./modules/linux-vm"

#   linux_vms                       = var.linux_vms
#   location                        = var.location
#   resource_group_name             = module.resource_group.resource_group_names["vm"]
#   tags                            = var.tags
#   subnet_id                       = module.vnet1.subnet_ids["mft"]
#   key_vault_id                    = module.key_vault.key_vault_id
#   custom_data_script              = var.linux_vm_custom_data_script
#   disk_encryption_set_id          = module.key_vault.disk_encryption_set_id
#   disable_password_authentication = var.linux_vm_disable_password_authentication
#   ssh_public_key                  = var.linux_vm_ssh_public_key

#   source_image_reference = var.linux_vm_source_image_reference
#   os_disk                = var.linux_os_disk
#   data_disk              = var.linux_data_disk
#   extensions             = var.linux_vm_extensions

#   depends_on = [
#     module.vnet1,
#     module.key_vault,
#     module.resource_group
#   ]
# }

#============
# PostGreSQL
#============

#========================
# Storage Account Module
#========================
#== VNet Peering Module - VM VNet to Hub ==#
module "vnet_peering_vm_to_hub" {
  source = "./modules/vnet-peering"

  providers = {
    azurerm.connectivity = azurerm.connectivity
  }

  peering_name_spoke_to_hub = "peer-vm-to-hub"
  peering_name_hub_to_spoke = "peer-hub-to-vm"
  spoke_vnet_name           = module.vnet1.vnet_name
  spoke_resource_group_name = module.resource_group.resource_group_names["vm"]
  spoke_vnet_id             = module.vnet1.vnet_id
  hub_vnet_name             = data.azurerm_virtual_network.hub.name
  hub_resource_group_name   = data.azurerm_virtual_network.hub.resource_group_name
  hub_vnet_id               = data.azurerm_virtual_network.hub.id
  use_remote_gateways       = false
  hub_allow_gateway_transit = false

  depends_on = [
    module.vnet1
  ]
}

#== VNet Peering Module - AKS VNet to Hub ==#
module "vnet_peering_aks_to_hub" {
  source = "./modules/vnet-peering"

  providers = {
    azurerm.connectivity = azurerm.connectivity
  }

  peering_name_spoke_to_hub = "peer-aks-to-hub"
  peering_name_hub_to_spoke = "peer-hub-to-aks"
  spoke_vnet_name           = module.vnet2.vnet_name
  spoke_resource_group_name = module.resource_group.resource_group_names["aks"]
  spoke_vnet_id             = module.vnet2.vnet_id
  hub_vnet_name             = data.azurerm_virtual_network.hub.name
  hub_resource_group_name   = data.azurerm_virtual_network.hub.resource_group_name
  hub_vnet_id               = data.azurerm_virtual_network.hub.id
  use_remote_gateways       = false
  hub_allow_gateway_transit = false

  depends_on = [
    module.vnet2
  ]
}












# Network IP Address Utility Module
# module "network_utils" {
#   source = "./modules/utils"

#   address_space = var.address_space
#   subnets       = var.subnets
# }
