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
  enable_vnet_peering_remote = false  # Disabled - using separate vnet-peering module
  vnet_peering_remote        = {}
  hub_vnet_id                = ""
  environment                = var.environment
  vnets                      = var.vnets
  routetables                = var.routetables
  nsg_snet                   = var.nsg_snet
  rg_details_input           = module.ResourceGroup.rg_details_output
}

# module "storage_account" {
#   source          = "./modules/Storage"
#   storage_accounts  = var.storage_accounts
#   snet_details_output = module.VirtualNetwork.snet_details_output
#   environment               = var.environment
# }

# module "KeyVault" {
#   source          = "./modules/KeyVault"
#   location        = var.location
#   tenant_id       = var.tenant_id
#   subscription_id = var.subscription_id
#   key_vault       = var.key_vault
#   resource_group_output = module.ResourceGroup.rg_details_output

#   Arcon_PAM_IP          = var.Arcon_PAM_IP
#   umbrella_ip_range     = var.umbrella_ip_range
#   AzureDevopsrunner     = var.AzureDevopsrunner
# }

# module "LogAnalytics" {
#   source                = "./modules/LogAnalytics"
#   location              = var.location
#   tenant_id             = var.tenant_id
#   subscription_id       = var.subscription_id
#   loganalytics          = var.loganalytics
#   resource_group_output = module.ResourceGroup.rg_details_output
# }

# module "AzureBackup" {
#   source                = "./modules/AzureBackup"
#   location              = var.location
#   tenant_id             = var.tenant_id
#   subscription_id       = var.subscription_id
#   BackupVault           = var.BackupVault
#   BackupPolicy          = var.BackupPolicy
#   resource_group_output = module.ResourceGroup.rg_details_output
# }

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
  
  peering_name_spoke_to_hub = "peer-nonprd-aks-to-hub"
  peering_name_hub_to_spoke = "peer-hub-to-nonprd-aks"
  spoke_vnet_name           = module.VirtualNetwork.vnet_details_output["vn1"].name
  spoke_resource_group_name = "rg-lnt-eip-aks-nonprd-uaen-01"
  spoke_vnet_id             = module.VirtualNetwork.vnet_details_output["vn1"].id
  hub_vnet_name             = data.azurerm_virtual_network.hub.name
  hub_resource_group_name   = data.azurerm_virtual_network.hub.resource_group_name
  hub_vnet_id               = data.azurerm_virtual_network.hub.id
  use_remote_gateways       = false
  hub_allow_gateway_transit = false

  depends_on = [
    module.VirtualNetwork
  ]
}

module "peering2" {
  source = "./modules/vnet-peering"

  providers = {
    azurerm.connectivity = azurerm.connectivity
  }
  
  peering_name_spoke_to_hub = "peer-nonprd-vm-to-hub"
  peering_name_hub_to_spoke = "peer-hub-to-nonprd-vm"
  spoke_vnet_name           = module.VirtualNetwork.vnet_details_output["vn2"].name
  spoke_resource_group_name = "rg-lnt-eip-vm-nonprd-uaen-01"
  spoke_vnet_id             = module.VirtualNetwork.vnet_details_output["vn2"].id
  hub_vnet_name             = data.azurerm_virtual_network.hub.name
  hub_resource_group_name   = data.azurerm_virtual_network.hub.resource_group_name
  hub_vnet_id               = data.azurerm_virtual_network.hub.id
  use_remote_gateways       = false
  hub_allow_gateway_transit = false

  depends_on = [
    module.VirtualNetwork
  ]
}

# pass pdz 

# module "KeyVault" {
#   source = "./modules/KeyVault"

#   # Pass DNS Zone IDs for private endpoints
#   dns_zone_ids = {
#     vaultcore = data.azurerm_private_dns_zone.dns_zones["privatelink.vaultcore.azure.net"].id
#     blob      = data.azurerm_private_dns_zone.dns_zones["privatelink.blob.core.windows.net"].id
#     azurecr   = data.azurerm_private_dns_zone.dns_zones["privatelink.azurecr.io"].id
#   }

#   # Other Key Vault variables
#   key_vault_name = var.key_vault_name
#   resource_group = var.resource_group
#   location       = var.location
# }
