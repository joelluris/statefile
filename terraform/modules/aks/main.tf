
# Flatten node pools for iteration
locals {
  node_pools = flatten([
    for aks_key, aks in var.aks : [
      for np_key, np in aks.node_pools : {
        aks_key                     = aks_key
        np_key                      = np_key
        name                        = np.name
        temporary_name_for_rotation = np.temporary_name_for_rotation
        zones                       = np.zones
        vm_size                     = np.vm_size
        max_count                   = np.max_count
        max_pods                    = np.max_pods
        min_count                   = np.min_count
        os_disk_size_gb             = np.os_disk_size_gb
        os_disk_type                = np.os_disk_type
        priority                    = np.priority
        spot_max_price              = np.spot_max_price
        eviction_policy             = np.eviction_policy
        vnet_subnet_id              = np.vnet_subnet_id
        # pod_subnet_id        = np.pod_subnet_id
        node_labels = np.node_labels
        node_taints = np.node_taints
        tags        = np.tags
      }
    ]
  ])
}

resource "azurerm_kubernetes_cluster" "aks" {
  for_each            = var.aks
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  dns_prefix          = each.value.dns_prefix
  tags                = each.value.tags

  sku_tier                            = each.value.sku_tier
  private_cluster_enabled             = each.value.private_cluster_enabled
  private_dns_zone_id                 = var.private_dns_zone_id != null ? var.private_dns_zone_id : "System"
  private_cluster_public_fqdn_enabled = each.value.private_cluster_enabled
  azure_policy_enabled                = each.value.azure_policy_enabled

  default_node_pool {
    name                         = "system01"
    temporary_name_for_rotation  = "system01b"
    only_critical_addons_enabled = each.value.only_critical_addons_enabled
    vm_size                      = each.value.node_vm_size
    os_disk_size_gb              = each.value.node_os_disk_size_gb
    auto_scaling_enabled         = each.value.auto_scaling_enabled
    node_count                   = each.value.aks_node_count
    max_pods                     = each.value.max_pods
    vnet_subnet_id               = var.vnet_subnet_id
    zones                        = [1, 2, 3]
  }

  auto_scaler_profile {
    expander = "least-waste"
  }

  automatic_upgrade_channel = "stable"
  node_os_upgrade_channel   = "NodeImage"

  maintenance_window {
    allowed {
      day   = "Sunday"
      hours = [0, 1, 2, 3]
    }
  }

  maintenance_window_auto_upgrade {
    frequency   = "Weekly"
    interval    = 1
    day_of_week = "Sunday"
    duration    = 4
    utc_offset  = "+00:00"
    start_time  = "00:00"
    start_date  = "2024-10-15T00:00:00Z"
  }

  maintenance_window_node_os {
    frequency   = "Weekly"
    interval    = 1
    day_of_week = "Sunday"
    duration    = 4
    utc_offset  = "+00:00"
    start_time  = "00:00"
    start_date  = "2024-10-15T00:00:00Z"
  }

  network_profile {
    network_plugin     = "azure"
    network_data_plane = "azure"
    network_policy     = "azure"
    service_cidr       = "10.96.0.0/16"
    dns_service_ip     = "10.96.0.10"
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  local_account_disabled    = each.value.enable_azure_ad

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = each.value.enable_azure_ad ? [1] : []
    content {
      admin_group_object_ids = var.admin_group_object_ids
    }
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.user_assigned_identity_ids[each.key]]
  }

  kubelet_identity {
    user_assigned_identity_id = var.kubelet_identity_ids[each.key]
  }

  storage_profile {
    blob_driver_enabled         = true
    disk_driver_enabled         = true
    file_driver_enabled         = true
    snapshot_controller_enabled = true
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "node_pools" {
  for_each = {
    for np in local.node_pools : "${np.aks_key}.${np.np_key}" => np
  }

  name                        = each.value.name
  kubernetes_cluster_id       = azurerm_kubernetes_cluster.aks[each.value.aks_key].id
  vnet_subnet_id              = var.subnet_ids[each.value.vnet_subnet_id]
  temporary_name_for_rotation = each.value.temporary_name_for_rotation

  zones                = each.value.zones
  vm_size              = each.value.vm_size
  os_disk_size_gb      = each.value.os_disk_size_gb
  os_disk_type         = each.value.os_disk_type
  node_labels          = each.value.node_labels
  node_taints          = each.value.node_taints
  auto_scaling_enabled = true
  min_count            = each.value.min_count
  max_count            = each.value.max_count
  max_pods             = each.value.max_pods
  priority             = each.value.priority
  spot_max_price       = each.value.spot_max_price
  eviction_policy      = each.value.eviction_policy
  tags                 = each.value.tags

  lifecycle {
    ignore_changes = [
      node_count,
    ]
  }
}
