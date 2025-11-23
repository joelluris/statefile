module "ResourceGroup" {
  source              = "./modules/ResourceGroup"
  location            = var.location
  tenant_id           = var.tenant_id
  subscription_id     = var.subscription_id
  all_resource_groups = var.all_resource_groups
}

module "VirtualNetwork" {
  # providers = {
  #   azurerm.LUNATE-SHARED_SERVICES = azurerm.LUNATE-SHARED_SERVICES
  # }

  providers = {
    azurerm.connectivity = azurerm.connectivity
  }

  source                     = "./modules/VirtualNetwork"
  location                   = var.location
  tenant_id                  = var.tenant_id
  subscription_id            = var.subscription_id
  tf_storage_resource_group  = var.tf_storage_resource_group
  tf_storage_account_name    = var.tf_storage_account_name
  tf_container_name          = var.tf_container_name
  tf_storage_access_key      = var.tf_storage_access_key
  enable_vnet_peering_remote = false
  vnet_peering_remote        = {}
  hub_vnet_id                = ""
  environment                = var.environment
  vnets                      = var.vnets
  routetables                = var.routetables
  nsg_snet                   = var.nsg_snet
  rg_details_input           = module.ResourceGroup.rg_details_output
}

module "storage_account" {
  source                     = "./modules/Storage-lun"
  storage_accounts           = var.storage_accounts
  snet_details_output        = module.VirtualNetwork.snet_details_output
  environment                = var.environment
  private_endpoint_subnet_id = module.VirtualNetwork.subnet_ids["vn1.sn3"] # snet-lnt-eip-privatelink-nonprd-uaen-01
  blob_dns_zone_id           = data.azurerm_private_dns_zone.dns_zones["privatelink.blob.core.windows.net"].id
}

module "KeyVault" {
  source                     = "./modules/KeyVault"
  location                   = var.location
  tenant_id                  = var.tenant_id
  subscription_id            = var.subscription_id
  key_vault                  = var.key_vault
  resource_group_output      = module.ResourceGroup.rg_ids["rg3"]
  private_endpoint_subnet_id = module.VirtualNetwork.subnet_ids["vn1.sn3"] # snet-lnt-eip-privatelink-nonprd-uaen-01
  kv_dns_zone_id             = data.azurerm_private_dns_zone.dns_zones["privatelink.vaultcore.azure.net"].id

  Arcon_PAM_IP      = var.Arcon_PAM_IP
  umbrella_ip_range = var.umbrella_ip_range
  AzureDevopsrunner = var.AzureDevopsrunner
}

module "acr" {
  source                        = "./modules/acr"
  acr                           = var.acr
  acr_dns_zone_id               = data.azurerm_private_dns_zone.dns_zones["privatelink.azurecr.io"].id
  private_endpoint_subnet_id    = module.VirtualNetwork.subnet_ids["vn1.sn3"] # snet-lnt-eip-privatelink-nonprd-uaen-01

  depends_on = [module.VirtualNetwork]
}

# module "LogAnalytics" {
#   source                = "./modules/LogAnalytics"
#   location              = var.location
#   tenant_id             = var.tenant_id
#   subscription_id       = var.subscription_id
#   loganalytics          = var.loganalytics
#   resource_group_output = module.ResourceGroup.rg_details_output
# }

module "AzureBackup" {
  source                = "./modules/AzureBackup"
  location              = var.location
  tenant_id             = var.tenant_id
  subscription_id       = var.subscription_id
  BackupVault           = var.BackupVault
  BackupPolicy          = var.BackupPolicy
  protected_vms         = var.protected_vms
  vm_ids                = module.windows_vm.vm_ids
  resource_group_output = module.ResourceGroup.rg_details_output

  depends_on = [module.windows_vm]
}

# module "AzurePolicy" {
#   source                           = "./modules/AzurePolicy"
#   location                         = var.location
#   tenant_id                        = var.tenant_id
#   subscription_id                  = var.subscription_id
#   Azure_Policy                     = var.Azure_Policy
#   Azure_Policy_Require_a_tag_on_rg = var.Azure_Policy_Require_a_tag_on_rg
# }

# module "Bastion" {
#   source = "./modules/Bastion"
#   providers = {
#     azurerm.LUNATE-SHARED_SERVICES = azurerm.LUNATE-SHARED_SERVICES
#   }

# providers = {
#   azurerm.connectivity = azurerm.connectivity
# }

#   bastion_id                       = data.azurerm_bastion_host.central_bastion.id
#   bastion_name                     = data.azurerm_bastion_host.central_bastion.name
#   bastion_rg                       = data.azurerm_bastion_host.central_bastion.resource_group_name
#   location                         = var.location
#   tenant_id                        = var.tenant_id
#   subscription_id                  = var.subscription_id
#   Azure_Policy                     = var.Azure_Policy
#   Azure_Policy_Require_a_tag_on_rg = var.Azure_Policy_Require_a_tag_on_rg
# }

module "peering" {
  source = "./modules/vnet-peering"

  providers = {
    azurerm.connectivity = azurerm.connectivity
  }

  # Merge VNet details with IDs from VirtualNetwork module
  vnets = {
    for k, v in var.vnets : k => merge(v, {
      vnet_id = module.VirtualNetwork.vnet_details_output[k].id
    })
  }

  hub_vnet_name             = data.azurerm_virtual_network.hub.name
  hub_resource_group_name   = data.azurerm_virtual_network.hub.resource_group_name
  hub_vnet_id               = data.azurerm_virtual_network.hub.id
  use_remote_gateways       = false
  hub_allow_gateway_transit = false

  depends_on = [
    module.VirtualNetwork
  ]
}

module "user_assigned_managed_identity" {
  source = "./modules/uami"

  user_assigned_managed_identities = var.user_assigned_managed_identity
  tenant_id                        = var.tenant_id
  subscription_id                  = var.subscription_id

  # Pass resource IDs for scope resolution
  rg_ids              = module.ResourceGroup.rg_ids
  key_vault_ids       = module.KeyVault.key_vault_ids # Add when Key Vault module is enabled
  storage_account_ids = {}                            # Add when Storage module is enabled
  acr_ids             = {}                            # ACR IDs for role assignments
  aks_ids             = {}                            # Don't pass AKS IDs to avoid circular dependency

  depends_on = [module.ResourceGroup]
}

module "aks" {
  source = "./modules/aks"
  aks    = var.aks

  # Subnet configuration:
  # - vnet_subnet_id: Direct subnet ID for the default/system node pool
  # - subnet_ids: Map of ALL subnets - allows additional node pools to reference subnets by key (e.g., "vn1.sn2")
  vnet_subnet_id      = module.VirtualNetwork.subnet_ids["vn1.sn2"] # Default node pool subnet (ND subnet)
  subnet_ids          = module.VirtualNetwork.subnet_ids            # Map for additional node pool lookups

  private_dns_zone_id = data.azurerm_private_dns_zone.dns_zones["privatelink.uaenorth.azmk8s.io"].id

  # Control plane identity (kubernetes_identity)
  user_assigned_identity_ids = {
    for k, v in var.aks : k => module.user_assigned_managed_identity.uami_ids["kubernetes_identity"]
  }

  # Kubelet identity for pulling images and accessing resources
  kubelet_identity_details = {
    for k, v in var.aks : k => module.user_assigned_managed_identity.uami_details["kubelet_identity"]
  }

  admin_group_object_ids = var.admin_group_object_ids

  depends_on = [module.VirtualNetwork, module.user_assigned_managed_identity]
}

module "windows_vm" {
  source = "./modules/windows-vm"

  windows_vms            = var.windows_vms
  subnet_ids             = module.VirtualNetwork.subnet_ids
  key_vault_id           = module.KeyVault.key_vault_ids["kv01"]
  custom_data_script     = var.windows_vm_custom_data_script
  disk_encryption_set_id = module.KeyVault.disk_encryption_set_id

  source_image_reference = var.win_vm_source_image_reference
  os_disk                = var.os_disk
  data_disk              = var.data_disk
  win_vm                 = var.win_vm
  extensions             = var.win_vm_extensions

  depends_on = [
    module.VirtualNetwork,
    module.KeyVault,
    module.ResourceGroup
  ]
}

module "linux_vm" {
  source = "./modules/linux-vm"

  linux_vms              = var.linux_vms
  subnet_ids             = module.VirtualNetwork.subnet_ids
  key_vault_id           = module.KeyVault.key_vault_ids["kv01"]
  custom_data_script     = var.linux_vm_custom_data_script
  disk_encryption_set_id = module.KeyVault.disk_encryption_set_id

  source_image_reference = var.linux_vm_source_image_reference
  os_disk                = var.os_disk
  data_disk              = var.data_disk
  linux_vm               = var.linux_vm
  extensions             = var.linux_vm_extensions

  depends_on = [
    module.VirtualNetwork,
    module.KeyVault,
    module.ResourceGroup
  ]
}

module "automation_account" {
  source = "./modules/automation-account"

  automation_accounts = var.automation_accounts
  runbooks            = var.automation_runbooks
  schedules           = var.automation_schedules
  job_schedules       = var.automation_job_schedules
  role_assignments    = var.automation_role_assignments

  depends_on = [module.ResourceGroup]
}

module "postgresql" {
  source = "./modules/postgresql"

  postgresql_servers               = var.postgresql_servers
  postgresql_databases             = var.postgresql_databases
  postgresql_firewall_rules        = var.postgresql_firewall_rules
  postgresql_virtual_network_rules = var.postgresql_virtual_network_rules
  subnet_ids                       = module.VirtualNetwork.subnet_ids
  key_vault_id                     = module.KeyVault.key_vault_ids["kv01"]
  postgresql_dns_zone_id           = data.azurerm_private_dns_zone.dns_zones["privatelink.postgres.database.azure.com"].id

  depends_on = [module.ResourceGroup, module.VirtualNetwork, module.KeyVault]
}
