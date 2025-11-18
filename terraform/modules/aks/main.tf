# resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
#   name                = var.aks_name
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   tags                = var.tags

#   sku_tier                            = "Free"
#   private_cluster_enabled             = true
#   private_dns_zone_id                 = var.private_dns_zone_id != null ? var.private_dns_zone_id : "System"
#   private_cluster_public_fqdn_enabled = false
#   dns_prefix                          = var.aks_dns_prefix
#   azure_policy_enabled                = true

#   default_node_pool {
#     name                         = "system01"
#     temporary_name_for_rotation  = "system01b"
#     only_critical_addons_enabled = true

#     vm_size         = var.aks_node_vm_size
#     os_disk_size_gb = 30

#     auto_scaling_enabled = false
#     node_count           = var.aks_node_count
#     max_pods             = 64
#     vnet_subnet_id       = var.vnet_subnet_id
#     pod_subnet_id        = var.pod_subnet_id
#     zones                = [1, 2, 3]
#   }

#   auto_scaler_profile {
#     expander = "least-waste"
#   }

#   automatic_upgrade_channel = "stable"
#   node_os_upgrade_channel   = "NodeImage"

#   maintenance_window {
#     allowed {
#       day   = "Sunday"
#       hours = [0, 1, 2, 3]
#     }
#   }

#   maintenance_window_auto_upgrade {
#     frequency   = "Weekly"
#     interval    = 1
#     day_of_week = "Sunday"
#     duration    = 4
#     utc_offset  = "+00:00"
#     start_time  = "00:00"
#     start_date  = "2024-10-15T00:00:00Z"
#   }

#   maintenance_window_node_os {
#     frequency   = "Weekly"
#     interval    = 1
#     day_of_week = "Sunday"
#     duration    = 4
#     utc_offset  = "+00:00"
#     start_time  = "00:00"
#     start_date  = "2024-10-15T00:00:00Z"
#   }

#   network_profile {
#     network_plugin     = "azure"
#     network_data_plane = "azure"
#     network_policy     = "azure"
#     service_cidr       = "10.96.0.0/16"
#     dns_service_ip     = "10.96.0.10"
#   }

#   oidc_issuer_enabled       = true
#   workload_identity_enabled = true
#   local_account_disabled    = true

#   azure_active_directory_role_based_access_control {
#     admin_group_object_ids = var.admin_group_object_ids
#   }

#   key_vault_secrets_provider {
#     secret_rotation_enabled = true
#   }

#   identity {
#     type         = "UserAssigned"
#     identity_ids = [var.user_assigned_identity]
#   }

#   # This is UAMI for kubelet
#   kubelet_identity {
#     client_id                 = var.kubelet_identity_client_id
#     object_id                 = var.kubelet_identity_object_id
#     user_assigned_identity_id = var.kubelet_identity_id
#   }

#   storage_profile {
#     blob_driver_enabled         = true
#     disk_driver_enabled         = true
#     file_driver_enabled         = true
#     snapshot_controller_enabled = true
#   }
# }

# resource "azurerm_kubernetes_cluster_node_pool" "this" {
#   for_each = {
#     for node_pool in var.node_pools : node_pool.name => node_pool
#   }

#   name                  = each.value.name
#   kubernetes_cluster_id = azurerm_kubernetes_cluster.kubernetes_cluster.id
#   vnet_subnet_id        = each.value.vnet_subnet_id
#   pod_subnet_id         = each.value.pod_subnet_id

#   zones                = each.value.zones
#   vm_size              = each.value.vm_size
#   os_disk_size_gb      = each.value.os_disk_size_gb
#   os_disk_type         = each.value.os_disk_type
#   node_labels          = each.value.node_labels
#   node_taints          = each.value.node_taints
#   auto_scaling_enabled = true
#   min_count            = each.value.min_count
#   max_count            = each.value.max_count
#   max_pods             = each.value.max_pods
#   priority             = each.value.priority
#   spot_max_price       = each.value.spot_max_price
#   eviction_policy      = each.value.eviction_policy

#   lifecycle {
#     ignore_changes = [
#       node_count,
#     ]
#   }
# }
