# Authentication variables (for local testing only - pipeline adds these dynamically)
# Comment out when running in pipeline
# tenant_id       = "7d1a04ec-981a-405a-951b-dd2733120e4c"
# subscription_id = "43731ed3-ead8-4406-b85d-18e966dfdb9f"


location    = "UAE North"
environment = "int"

all_resource_groups = {
  rg1 = {
    name = "rg-lnt-eip-aks-nonprd-uaen-01"
    tags = {
      "Application Owner"    = "IT"
      "Business Criticality" = "Essential"
      "Environment"          = "Integrations"
    }
  }
  rg2 = {
    name = "rg-lnt-eip-vm-nonprd-uaen-01"
    tags = {
      "Application Owner"    = "IT"
      "Business Criticality" = "Essential"
      "Environment"          = "Integration"
    }
  }
  rg3 = {
    name = "rg-lnt-eip-mgmt-nonprd-uaen-01"
    tags = {
      "Application Owner"    = "IT"
      "Business Criticality" = "Essential"
      "Environment"          = "Integration"
    }
  }
  # rg4 = {
  #   name = "rg-app-sec-dev-uaen-01"
  #   tags = {
  #     "Application Owner"    = "IT"
  #     "Business Criticality" = "Essential"
  #     "Environment"          = "Integration"
  #   }
  # }
}

vnets = {
  vn1 = {
    name    = "vnet-lnt-eip-nonprd-uaen-01"
    rg_name = "rg-lnt-eip-aks-nonprd-uaen-01"
    cidr    = ["10.5.0.0/20"]
    dns     = ["168.63.129.16"]
    tags = {
      "Application Owner"    = "IT"
      "Business Criticality" = "Essential"
      "Environment"          = "Integration"
    }
    subnets = {
      sn1 = {
        name               = "snet-lnt-eip-mft-nonprd-uaen-01"
        cidr               = "10.5.8.64/26"
        service_delegation = ""
      }
      sn2 = {
        name               = "snet-lnt-eip-nd-nonprd-uaen-01"
        cidr               = "10.5.0.0/24"
        service_delegation = ""
      }
      sn3 = {
        name               = "snet-lnt-eip-privatelink-nonprd-uaen-01"
        cidr               = "10.5.1.0/24"
        service_delegation = ""
      }
      sn4 = {
        name = "snet-lnt-eip-psql-nonprd-01"
        cidr = "10.5.7.0/28"
        # service_delegation = "Microsoft.DBforPostgreSQL/flexibleServers" # Comment if not needed
        service_delegation = ""
      }
      sn5 = {
        name               = "snet-lnt-eip-vm-nonprd-uaen-01"
        cidr               = "10.5.8.0/26"
        service_delegation = ""
      }
    }
  }
  vn2 = {
    name    = "vnet-lnt-vm-nonprd-uaen-01"
    rg_name = "rg-lnt-eip-vm-nonprd-uaen-01"
    cidr    = ["10.6.0.0/20"]
    dns     = ["168.63.129.16"]
    tags = {
      "Application Owner"    = "IT"
      "Business Criticality" = "Essential"
      "Environment"          = "Integration"
    }
    subnets = {
      sn1 = {
        name               = "snet-lnt-eip-mft-nonprd-uaen-01"
        cidr               = "10.6.0.0/24"
        service_delegation = ""
      }
    }
  }
}

nsg_snet = {
  nsg-01 = {
    name      = "nsg-lnt-eip-mft-nonprd-uaen-01"
    rg_name   = "rg-lnt-eip-aks-nonprd-uaen-01"
    vnet_name = "vnet-lnt-eip-nonprd-uaen-01"
    snet_name = "snet-lnt-eip-mft-nonprd-uaen-01"
    tags = {
      "Application Owner"    = "IT"
      "Business Criticality" = "Critical"
      "Environment"          = "Integration"
    }
    rules = [
      # {
      #   name                         = "AllowSSH"
      #   access                       = "Allow"
      #   destination_address_prefix   = "*"
      #   destination_address_prefixes = []
      #   destination_port_range       = "22"
      #   destination_port_ranges      = []
      #   direction                    = "Inbound"
      #   priority                     = 1001
      #   protocol                     = "Tcp"
      #   source_address_prefix        = "*"
      #   source_port_range            = "*"
      # },
    ]
  }

  nsg-02 = {
    name      = "nsg-lnt-eip-nd-nonprd-uaen-01"
    rg_name   = "rg-lnt-eip-aks-nonprd-uaen-01"
    vnet_name = "vnet-lnt-eip-nonprd-uaen-01"
    snet_name = "snet-lnt-eip-nd-nonprd-uaen-01"
    tags = {
      "Application Owner"    = "IT"
      "Business Criticality" = "Critical"
      "Environment"          = "Integration"
    }
    rules = []
  }

  nsg-03 = {
    name      = "nsg-lnt-eip-privatelink-nonprd-uaen-01"
    rg_name   = "rg-lnt-eip-aks-nonprd-uaen-01"
    vnet_name = "vnet-lnt-eip-nonprd-uaen-01"
    snet_name = "snet-lnt-eip-privatelink-nonprd-uaen-01"
    tags = {
      "Application Owner"    = "IT"
      "Business Criticality" = "Critical"
      "Environment"          = "Integration"
    }
    rules = []
  }

  nsg-04 = {
    name      = "nsg-lnt-eip-psql-nonprd-01"
    rg_name   = "rg-lnt-eip-aks-nonprd-uaen-01"
    vnet_name = "vnet-lnt-eip-nonprd-uaen-01"
    snet_name = "snet-lnt-eip-psql-nonprd-01"
    tags = {
      "Application Owner"    = "IT"
      "Business Criticality" = "Critical"
      "Environment"          = "Integration"
    }
    rules = []
  }

  nsg-05 = {
    name      = "nsg-lnt-eip-vm-nonprd-uaen-01"
    rg_name   = "rg-lnt-eip-aks-nonprd-uaen-01"
    vnet_name = "vnet-lnt-eip-nonprd-uaen-01"
    snet_name = "snet-lnt-eip-vm-nonprd-uaen-01"
    tags = {
      "Application Owner"    = "IT"
      "Business Criticality" = "Critical"
      "Environment"          = "Integration"
    }
    rules = []
  }
}

enable_vnet_peering_remote = true

vnet_peering_remote = {
  peering1 = {
    remote_environment           = "hub"
    source_vnet_name             = "vnet-lnt-eip-nonprd-uaen-01"
    remote_vnet_name             = "vnet-hub-uaenorth"
    resource_group_name          = "rg-lnt-eip-aks-nonprd-uaen-01"
    remote_resource_group_name   = "rg-hub-uaenorth"
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
    use_remote_gateways          = false
  }
}

routetables = {
  rt1 = {
    name                          = "rt-nonprd-mft-uaen-01"
    rg_name                       = "rg-lnt-eip-aks-nonprd-uaen-01"
    vnet_name                     = "vnet-lnt-eip-nonprd-uaen-01"
    snet_name                     = "snet-lnt-eip-mft-nonprd-uaen-01"
    bgp_route_propagation_enabled = false
    tags = {
      "Application Owner"    = "IT"
      "Business Criticality" = "Essential"
      "Environment"          = "Integrations"
    }
    routes = {
      route1 = {
        name             = "route-to-firewall"
        address_prefixes = ["0.0.0.0/0"]
        next_hop_type    = "VirtualAppliance"
        next_hop_ip      = "10.0.5.4"
      }
      // route2 = {
      //   name             = "route-to-gatewaysubnet"
      //   address_prefixes = ["10.0.2.0/27"]
      //   next_hop_type    = "VirtualAppliance"
      //   next_hop_ip      = "10.0.5.4"
      // }
      // route3 = {
      //   name             = "route-to-hub"
      //   address_prefixes = ["10.0.0.0/20"]
      //   next_hop_type    = "VirtualAppliance"
      //   next_hop_ip      = "10.0.5.4"
      // }
    }
  }

  rt2 = {
    name                          = "rt-nonprd-nd-uaen-01"
    rg_name                       = "rg-lnt-eip-aks-nonprd-uaen-01"
    vnet_name                     = "vnet-lnt-eip-nonprd-uaen-01"
    snet_name                     = "snet-lnt-eip-nd-nonprd-uaen-01"
    bgp_route_propagation_enabled = false
    tags = {
      "Application Owner"    = "IT"
      "Business Criticality" = "Essential"
      "Environment"          = "Integrations"
    }
    routes = {
      route1 = {
        name             = "route-to-firewall"
        address_prefixes = ["0.0.0.0/0"]
        next_hop_type    = "VirtualAppliance"
        next_hop_ip      = "10.0.5.4"
      }
      // route2 = {
      //   name             = "route-to-gatewaysubnet"
      //   address_prefixes = ["10.0.2.0/27"]
      //   next_hop_type    = "VirtualAppliance"
      //   next_hop_ip      = "10.0.5.4"
      // }
      // route3 = {
      //   name             = "route-to-hub"
      //   address_prefixes = ["10.0.0.0/20"]
      //   next_hop_type    = "VirtualAppliance"
      //   next_hop_ip      = "10.0.5.4"
      // }
    }
  }

  rt3 = {
    name                          = "rt-nonprd-vm-uaen-01"
    rg_name                       = "rg-lnt-eip-aks-nonprd-uaen-01"
    vnet_name                     = "vnet-lnt-eip-nonprd-uaen-01"
    snet_name                     = "snet-lnt-eip-privatelink-nonprd-uaen-01"
    bgp_route_propagation_enabled = false
    tags = {
      "Application Owner"    = "IT"
      "Business Criticality" = "Essential"
      "Environment"          = "Integrations"
    }
    routes = {
      route1 = {
        name             = "route-to-firewall"
        address_prefixes = ["0.0.0.0/0"]
        next_hop_type    = "VirtualAppliance"
        next_hop_ip      = "10.0.5.4"
      }
      // route2 = {
      //   name             = "route-to-gatewaysubnet"
      //   address_prefixes = ["10.0.2.0/27"]
      //   next_hop_type    = "VirtualAppliance"
      //   next_hop_ip      = "10.0.5.4"
      // }
      // route3 = {
      //   name             = "route-to-hub"
      //   address_prefixes = ["10.0.0.0/20"]
      //   next_hop_type    = "VirtualAppliance"
      //   next_hop_ip      = "10.0.5.4"
      // }
    }
  }
  rt4 = {
    name                          = "rt-nonprd-psql-uaen-01"
    rg_name                       = "rg-lnt-eip-aks-nonprd-uaen-01"
    vnet_name                     = "vnet-lnt-eip-nonprd-uaen-01"
    snet_name                     = "snet-lnt-eip-psql-nonprd-01"
    bgp_route_propagation_enabled = false
    tags = {
      "Application Owner"    = "IT"
      "Business Criticality" = "Essential"
      "Environment"          = "Integrations"
    }
    routes = {
      route1 = {
        name             = "route-to-firewall"
        address_prefixes = ["0.0.0.0/0"]
        next_hop_type    = "VirtualAppliance"
        next_hop_ip      = "10.0.5.4"
      }
      // route2 = {
      //   name             = "route-to-gatewaysubnet"
      //   address_prefixes = ["10.0.2.0/27"]
      //   next_hop_type    = "VirtualAppliance"
      //   next_hop_ip      = "10.0.5.4"
      // }
      // route3 = {
      //   name             = "route-to-hub"
      //   address_prefixes = ["10.0.0.0/20"]
      //   next_hop_type    = "VirtualAppliance"
      //   next_hop_ip      = "10.0.5.4"
      // }
    }
  }
  rt5 = {
    name                          = "rt-nonprd-vm-uaen-01"
    rg_name                       = "rg-lnt-eip-aks-nonprd-uaen-01"
    vnet_name                     = "vnet-lnt-eip-nonprd-uaen-01"
    snet_name                     = "snet-lnt-eip-vm-nonprd-uaen-01"
    bgp_route_propagation_enabled = false
    tags = {
      "Application Owner"    = "IT"
      "Business Criticality" = "Essential"
      "Environment"          = "Integrations"
    }
    routes = {
      route1 = {
        name             = "route-to-firewall"
        address_prefixes = ["0.0.0.0/0"]
        next_hop_type    = "VirtualAppliance"
        next_hop_ip      = "10.0.5.4"
      }
      // route2 = {
      //   name             = "route-to-gatewaysubnet"
      //   address_prefixes = ["10.0.2.0/27"]
      //   next_hop_type    = "VirtualAppliance"
      //   next_hop_ip      = "10.0.5.4"
      // }
      // route3 = {
      //   name             = "route-to-hub"
      //   address_prefixes = ["10.0.0.0/20"]
      //   next_hop_type    = "VirtualAppliance"
      //   next_hop_ip      = "10.0.5.4"
      // }
    }
  }
}

storage_accounts = {
  sa1 = {
    resource_group_name        = "rg-lnt-eip-aks-nonprd-uaen-01"
    location                   = "UAE North"
    storage_account_name       = "stlntnonprduaen01"
    account_tier               = "Standard"
    account_replication_type   = "LRS"
    https_traffic_only_enabled = true
    tags = {
      "Application Owner"    = "IT"
      "Business Criticality" = "Essential"
      "Environment"          = "Integrations"
    }
  }
}

key_vault = {
  kv01 = {
    kv_name    = "kv-lnt-nonprd-uaen-01"
    kv_rg_name = "rg-lnt-eip-aks-nonprd-uaen-01" # Using rg1
    sku        = "standard"
    tags = {
      "Application Owner"    = "IT"
      "Business Criticality" = "Essential"
      "Environment"          = "Integrations"
    }
  }
}

# loganalytics = {
#   law01 = {
#     name                = "law-dev-uaen-01"
#     resource_group_name = "rg-mgmt-dev-uaen-01"
#     sku                 = "PerGB2018"
#     tags = {
#       "Application Owner"    = "IT"
#       "Business Criticality" = "Essential"
#       "Environment"          = "Integrations"
#     }
#   }
# } }

BackupVault = {
  vault1 = {
    rsv_vault_name          = "rsv-lnt-eip-nonprd-uaen-01"
    rsv_resource_group_name = "rg-lnt-eip-aks-nonprd-uaen-01"
    location                = "UAE North"
    rsv_vault_sku           = "Standard"
    soft_delete_enabled     = true
    tags = {
      "Application Owner"    = "IT"
      "Business Criticality" = "Essential"
      "Environment"          = "Integrations"
    }
  }
}

# BackupPolicy = {
#   policy1 = {
#     backup_policy_name             = "vm-bkp-policy-01"
#     rsv_resource_group_name        = "rg-mgmt-dev-uaen-01"
#     rsv_vault_name                 = "rsv-lnt-eip-aks-nonprd-uaen-01"
#     timezone                       = "UTC"
#     instant_restore_retention_days = 2

#     # Backup Frequency
#     backup_frequency = "Daily"
#     backup_time      = "23:00"

#     # Retention Policies
#     retention_daily       = 7
#     retention_weekly      = 4
#     retention_weekly_days = ["Sunday"]

#     retention_monthly      = 12
#     retention_monthly_week = ["First"]
#     retention_monthly_days = ["Sunday"]

#     retention_yearly       = 5
#     retention_yearly_month = ["January"]
#     retention_yearly_week  = ["First"]
#     retention_yearly_days  = ["Sunday"]
#   }
# }

Azure_Policy = {
  Allowed_locations = {
    Name              = "Allowed locations"
    Allowed_locations = ["UAE North", "East US"]
  }
  No_Public_IPs_on_NICs = {
    Name = "Network Interfaces Should Not Have Public IPs"
  }
  allowed_vm_skus = {
    Name = "Allowed_VM_SKUs"
    allowed_skus = [
      "Standard_B2as_v2", "Standard_B2ats_v2", "Standard_B2ms", "Standard_B2s", "Standard_B2s_v2", "Standard_B2ts_v2", "Standard_B4as_v2", "Standard_B4ms",
      "Standard_B4s_v2", "Standard_D11", "Standard_D11_v2", "Standard_D12", "Standard_D12_v2", "Standard_D13", "Standard_D13_v2", "Standard_D16_v3",
      "Standard_D16_v4", "Standard_D16_v5", "Standard_D16a_v4", "Standard_D16ads_v5", "Standard_D16as_v4", "Standard_D16as_v5", "Standard_D16d_v4",
      "Standard_D16d_v5", "Standard_D16ds_v4", "Standard_D16ds_v5", "Standard_D16s_v3", "Standard_D16s_v4", "Standard_D16s_v5", "Standard_D2",
      "Standard_D2_v2", "Standard_D2_v3", "Standard_D2_v4", "Standard_D2_v5", "Standard_D2a_v4", "Standard_D2ads_v5", "Standard_D2as_v4", "Standard_D2as_v5",
      "Standard_D2d_v4", "Standard_D2d_v5", "Standard_D2ds_v4", "Standard_D2ds_v5", "Standard_D2s_v3", "Standard_D2s_v4", "Standard_D2s_v5", "Standard_D3",
      "Standard_D3_v2", "Standard_D4", "Standard_D4_v2", "Standard_D4_v3", "Standard_D4_v4", "Standard_D4_v5", "Standard_D4a_v4", "Standard_D4ads_v5",
      "Standard_D4as_v4", "Standard_D4as_v5", "Standard_D4d_v4", "Standard_D4d_v5", "Standard_D4ds_v4", "Standard_D4ds_v5", "Standard_D4s_v3",
      "Standard_D4s_v4", "Standard_D4s_v5", "Standard_D5_v2", "Standard_D8_v3", "Standard_D8_v4", "Standard_D8_v5", "Standard_D8a_v4", "Standard_D8ads_v5",
      "Standard_D8as_v4", "Standard_D8as_v5", "Standard_D8d_v4", "Standard_D8d_v5", "Standard_D8ds_v4", "Standard_D8ds_v5", "Standard_D8s_v3", "Standard_D8s_v4",
      "Standard_D8s_v5", "Standard_DC16ads_v5", "Standard_DC16as_v5", "Standard_DC2ads_v5", "Standard_DC2as_v5", "Standard_DC2ds_v3", "Standard_DC2s_v3",
      "Standard_DC4ads_v5", "Standard_DC4as_v5", "Standard_DC4ds_v3", "Standard_DC4s_v3", "Standard_DC8ads_v5", "Standard_DC8as_v5", "Standard_DC8ds_v3",
      "Standard_DC8s_v3", "Standard_DS11", "Standard_DS11_v2", "Standard_DS12", "Standard_DS12_v2", "Standard_DS12-2_v2", "Standard_DS13", "Standard_DS13_v2",
      "Standard_DS13-2_v2", "Standard_DS13-4_v2", "Standard_DS2", "Standard_DS2_v2", "Standard_DS3", "Standard_DS3_v2", "Standard_DS4", "Standard_DS4_v2",
      "Standard_DS5_v2", "Standard_E2_v3", "Standard_E2_v4", "Standard_E2_v5", "Standard_E2a_v4", "Standard_E2ads_v5", "Standard_E2as_v4", "Standard_E2as_v5",
      "Standard_E2d_v4", "Standard_E2d_v5", "Standard_E2ds_v4", "Standard_E2ds_v5", "Standard_E2s_v3", "Standard_E2s_v4", "Standard_E2s_v5", "Standard_E4_v3",
      "Standard_E4_v4", "Standard_E4_v5", "Standard_E4-2ads_v5", "Standard_E4-2as_v4", "Standard_E4-2as_v5", "Standard_E4-2ds_v4", "Standard_E4-2ds_v5",
      "Standard_E4-2s_v3", "Standard_E4-2s_v4", "Standard_E4-2s_v5", "Standard_E4a_v4", "Standard_E4ads_v5", "Standard_E4as_v4", "Standard_E4as_v5",
      "Standard_E4d_v4", "Standard_E4d_v5", "Standard_E4ds_v4", "Standard_E4ds_v5", "Standard_E4s_v3", "Standard_E4s_v4", "Standard_E4s_v5", "Standard_E8_v3",
      "Standard_E8_v4", "Standard_E8_v5", "Standard_E8-2ads_v5", "Standard_E8-2as_v4", "Standard_E8-2as_v5", "Standard_E8-2ds_v4", "Standard_E8-2ds_v5",
      "Standard_E8-2s_v3", "Standard_E8-2s_v4", "Standard_E8-2s_v5", "Standard_E8-4ads_v5", "Standard_E8-4as_v4", "Standard_E8-4as_v5", "Standard_E8-4ds_v4",
      "Standard_E8-4ds_v5", "Standard_E8-4s_v3", "Standard_E8-4s_v4", "Standard_E8-4s_v5", "Standard_E8a_v4", "Standard_E8ads_v5", "Standard_E8as_v4",
      "Standard_E8as_v5", "Standard_E8d_v4", "Standard_E8d_v5", "Standard_E8ds_v4", "Standard_E8ds_v5", "Standard_E8s_v3", "Standard_E8s_v4", "Standard_E8s_v5",
      "Standard_EC2ads_v5", "Standard_EC2as_v5", "Standard_EC4ads_v5", "Standard_EC4as_v5", "Standard_EC8ads_v5", "Standard_EC8as_v5", "Standard_F16",
      "Standard_F16s", "Standard_F16s_v2", "Standard_F2", "Standard_F2s", "Standard_F2s_v2", "Standard_F32s_v2", "Standard_F4", "Standard_F4s", "Standard_F4s_v2",
      "Standard_F8", "Standard_F8s", "Standard_F8s_v2"
    ]
  }
  Audit_VM_AzureBackup = {
    Name = "Audit Virtual Machines With No Backup Enabled"
  }
  Audit_VM_EncryptionatHost = {
    Name = "Audit Virtual Machine Encryption at Host"
  }
}

Azure_Policy_Require_a_tag_on_rg = {
  tag1 = {
    Name    = "Require an Environment tag on resource groups"
    TagName = "Environment"
  }
  tag2 = {
    Name    = "Require a Business Criticality tag on resource groups"
    TagName = "Business Criticality"
  }
  tag3 = {
    Name    = "Require an Application Owner tag on resource groups"
    TagName = "Application Owner"
  }
}

# Bastion details (from existing Bastion)
# bastion_id   = "/subscriptions/8041dff6-8186-4b97-9b32-365b16d0b28b/resourceGroups/rg-app-sec-shared-uaen-01/providers/Microsoft.Network/bastionHosts/bas-shared-uaen-01"
# bastion_name = "bas-shared-uaen-01"
# bastion_rg   = "rg-app-sec-shared-uaen-01"

user_assigned_managed_identity = {
  workload_identity = {
    name     = "uami-lnt-eip-nonprd-uaen-01"
    rg_name  = "rg-lnt-eip-aks-nonprd-uaen-01"
    location = "UAE North"
    role_assignments = {
      # ra1 = {
      #   role_definition_name = "Contributor"
      #   scope_type           = "resource_group"
      #   scope                = "rg1"
      # }
      ra2 = {
        role_definition_name = "Key Vault Secrets User"
        scope_type           = "key_vault"
        scope                = "kv-lnt-nonprd-uaen-01"
      }
      # ra3 = {
      #   role_definition_name = "AcrPush"
      #   scope_type           = "azure_container_registry"
      #   scope                = ""
      # }
      # ra4 = {
      #   role_definition_name = "AcrDelete"
      #   scope_type           = "azure_container_registry"
      #   scope                = ""
      # }
    }
  },
  kubernetes_identity = {
    name     = "kubernetes-lnt-eip-aks-nonprd-uaen-01"
    rg_name  = "rg-lnt-eip-aks-nonprd-uaen-01"
    location = "UAE North"
    role_assignments = {
      ra1 = {
        role_definition_name = "Managed Identity Operator"
        scope_type           = "user_assigned_managed_identity"
        scope                = "kubelet-lnt-eip-aks-kubelet-nonprd-uaen-01"
      }
      ra2 = {
        role_definition_name = "Contributor"
        scope_type           = "resource_group"
        scope                = "rg1"
      }
      # ra3 = {
      #   role_definition_name = "Private DNS Zone Contributor"
      #   scope_type           = "private_dns_zone"
      #   scope                = ""
      # }
    }
  },
  kubelet_identity = {
    name     = "kubelet-lnt-eip-aks-kubelet-nonprd-uaen-01"
    rg_name  = "rg-lnt-eip-aks-nonprd-uaen-01"
    location = "UAE North"
    role_assignments = {
      # ra1 = {
      #   role_definition_name = "AcrPull"
      #   scope_type           = "azure_container_registry"
      #   scope                = ""
      # }
    }
  }
}

acr = {
  acr1 = {
    name                = "acrlnteipnonprd01"
    resource_group_name = "rg-lnt-eip-aks-nonprd-uaen-01"
    location            = "UAE North"
    sku                 = "Basic"
    admin_enabled       = false
    tags = {
      "Application Owner"    = "IT"
      "Business Criticality" = "Essential"
      "Environment"          = "Integrations"
    }
  }
}

aks = {
  aks
}