# Authentication variables (for local testing only - pipeline adds these dynamically)
# Comment out when running in pipeline
tenant_id       = "7d1a04ec-981a-405a-951b-dd2733120e4c"
subscription_id = "43731ed3-ead8-4406-b85d-18e966dfdb9f"

management_subscription_id        = "42dedbdb-3ad0-438c-a796-66bb1c08686a"
log_analytics_workspace_name      = "law-management-uaenorth"
log_analytics_resource_group_name = "rg-management-uaenorth"

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
    name = "rg-lnt-eip-nonprd-uaen-01" # This RG is for resources that  has private endpoints like Key Vault, Storage Account etc.
    tags = {
      "Application Owner"    = "IT"
      "Business Criticality" = "Essential"
      "Environment"          = "Integration"
    }
  }
  rg4 = {
    name = "rg-lnt-eip-mft-nonprd-uaen-01"
    tags = {
      "Application Owner"    = "IT"
      "Business Criticality" = "Essential"
      "Environment"          = "Integration"
    }
  }
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
    rules = [
      {
        name                         = "Allow-RDP"
        access                       = "Allow"
        destination_address_prefix   = "*"
        destination_address_prefixes = []
        destination_port_range       = "3389"
        destination_port_ranges      = []
        direction                    = "Inbound"
        priority                     = 1000
        protocol                     = "Tcp"
        source_address_prefix        = "*"
        source_port_range            = "*"
      },
    ]
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

# routetables = {
#   rt1 = {
#     name                          = "rt-nonprd-mft-uaen-01"
#     rg_name                       = "rg-lnt-eip-aks-nonprd-uaen-01"
#     vnet_name                     = "vnet-lnt-eip-nonprd-uaen-01"
#     snet_name                     = "snet-lnt-eip-mft-nonprd-uaen-01"
#     bgp_route_propagation_enabled = false
#     tags = {
#       "Application Owner"    = "IT"
#       "Business Criticality" = "Essential"
#       "Environment"          = "Integrations"
#     }
#     routes = {
#       route1 = {
#         name             = "route-to-firewall"
#         address_prefixes = ["0.0.0.0/0"]
#         next_hop_type    = "VirtualAppliance"
#         next_hop_ip      = "10.0.5.4"
#       }
#       // route2 = {
#       //   name             = "route-to-gatewaysubnet"
#       //   address_prefixes = ["10.0.2.0/27"]
#       //   next_hop_type    = "VirtualAppliance"
#       //   next_hop_ip      = "10.0.5.4"
#       // }
#       // route3 = {
#       //   name             = "route-to-hub"
#       //   address_prefixes = ["10.0.0.0/20"]
#       //   next_hop_type    = "VirtualAppliance"
#       //   next_hop_ip      = "10.0.5.4"
#       // }
#     }
#   }

#   rt2 = {
#     name                          = "rt-nonprd-nd-uaen-01"
#     rg_name                       = "rg-lnt-eip-aks-nonprd-uaen-01"
#     vnet_name                     = "vnet-lnt-eip-nonprd-uaen-01"
#     snet_name                     = "snet-lnt-eip-nd-nonprd-uaen-01"
#     bgp_route_propagation_enabled = false
#     tags = {
#       "Application Owner"    = "IT"
#       "Business Criticality" = "Essential"
#       "Environment"          = "Integrations"
#     }
#     routes = {
#       route1 = {
#         name             = "route-to-firewall"
#         address_prefixes = ["0.0.0.0/0"]
#         next_hop_type    = "VirtualAppliance"
#         next_hop_ip      = "10.0.5.4"
#       }
#       // route2 = {
#       //   name             = "route-to-gatewaysubnet"
#       //   address_prefixes = ["10.0.2.0/27"]
#       //   next_hop_type    = "VirtualAppliance"
#       //   next_hop_ip      = "10.0.5.4"
#       // }
#       // route3 = {
#       //   name             = "route-to-hub"
#       //   address_prefixes = ["10.0.0.0/20"]
#       //   next_hop_type    = "VirtualAppliance"
#       //   next_hop_ip      = "10.0.5.4"
#       // }
#     }
#   }

#   rt3 = {
#     name                          = "rt-nonprd-vm-uaen-01"
#     rg_name                       = "rg-lnt-eip-aks-nonprd-uaen-01"
#     vnet_name                     = "vnet-lnt-eip-nonprd-uaen-01"
#     snet_name                     = "snet-lnt-eip-privatelink-nonprd-uaen-01"
#     bgp_route_propagation_enabled = false
#     tags = {
#       "Application Owner"    = "IT"
#       "Business Criticality" = "Essential"
#       "Environment"          = "Integrations"
#     }
#     routes = {
#       route1 = {
#         name             = "route-to-firewall"
#         address_prefixes = ["0.0.0.0/0"]
#         next_hop_type    = "VirtualAppliance"
#         next_hop_ip      = "10.0.5.4"
#       }
#       // route2 = {
#       //   name             = "route-to-gatewaysubnet"
#       //   address_prefixes = ["10.0.2.0/27"]
#       //   next_hop_type    = "VirtualAppliance"
#       //   next_hop_ip      = "10.0.5.4"
#       // }
#       // route3 = {
#       //   name             = "route-to-hub"
#       //   address_prefixes = ["10.0.0.0/20"]
#       //   next_hop_type    = "VirtualAppliance"
#       //   next_hop_ip      = "10.0.5.4"
#       // }
#     }
#   }
#   rt4 = {
#     name                          = "rt-nonprd-psql-uaen-01"
#     rg_name                       = "rg-lnt-eip-aks-nonprd-uaen-01"
#     vnet_name                     = "vnet-lnt-eip-nonprd-uaen-01"
#     snet_name                     = "snet-lnt-eip-psql-nonprd-01"
#     bgp_route_propagation_enabled = false
#     tags = {
#       "Application Owner"    = "IT"
#       "Business Criticality" = "Essential"
#       "Environment"          = "Integrations"
#     }
#     routes = {
#       route1 = {
#         name             = "route-to-firewall"
#         address_prefixes = ["0.0.0.0/0"]
#         next_hop_type    = "VirtualAppliance"
#         next_hop_ip      = "10.0.5.4"
#       }
#       // route2 = {
#       //   name             = "route-to-gatewaysubnet"
#       //   address_prefixes = ["10.0.2.0/27"]
#       //   next_hop_type    = "VirtualAppliance"
#       //   next_hop_ip      = "10.0.5.4"
#       // }
#       // route3 = {
#       //   name             = "route-to-hub"
#       //   address_prefixes = ["10.0.0.0/20"]
#       //   next_hop_type    = "VirtualAppliance"
#       //   next_hop_ip      = "10.0.5.4"
#       // }
#     }
#   }
#   rt5 = {
#     name                          = "rt-nonprd-vm-uaen-01"
#     rg_name                       = "rg-lnt-eip-aks-nonprd-uaen-01"
#     vnet_name                     = "vnet-lnt-eip-nonprd-uaen-01"
#     snet_name                     = "snet-lnt-eip-vm-nonprd-uaen-01"
#     bgp_route_propagation_enabled = false
#     tags = {
#       "Application Owner"    = "IT"
#       "Business Criticality" = "Essential"
#       "Environment"          = "Integrations"
#     }
#     routes = {
#       route1 = {
#         name             = "route-to-firewall"
#         address_prefixes = ["0.0.0.0/0"]
#         next_hop_type    = "VirtualAppliance"
#         next_hop_ip      = "10.0.5.4"
#       }
#       // route2 = {
#       //   name             = "route-to-gatewaysubnet"
#       //   address_prefixes = ["10.0.2.0/27"]
#       //   next_hop_type    = "VirtualAppliance"
#       //   next_hop_ip      = "10.0.5.4"
#       // }
#       // route3 = {
#       //   name             = "route-to-hub"
#       //   address_prefixes = ["10.0.0.0/20"]
#       //   next_hop_type    = "VirtualAppliance"
#       //   next_hop_ip      = "10.0.5.4"
#       // }
#     }
#   }
# }

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
    kv_name                       = "kv-lnt-nonprd-uaen-01"
    kv_rg_name                    = "rg-lnt-eip-nonprd-uaen-01"
    sku                           = "standard"
    purge_protection_enabled      = true # Required by Azure Policy
    soft_delete_retention_days    = 7    # Minimum allowed: 7 days
    public_network_access_enabled = true # Enable for Terraform deployment, disable after via portal/policy
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

BackupPolicy = {
  policy1 = {
    backup_policy_name             = "vm-bkp-policy-daily"
    rsv_resource_group_name        = "rg-lnt-eip-nonprd-uaen-01"
    rsv_vault_name                 = "rsv-lnt-eip-nonprd-uaen-01"
    timezone                       = "Arabian Standard Time"
    instant_restore_retention_days = 2

    # Backup Frequency
    backup_frequency = "Daily"
    backup_time      = "23:30"

    # Retention Policies
    retention_daily       = 7
    retention_weekly      = 4
    retention_weekly_days = ["Sunday"]

    retention_monthly      = 12
    retention_monthly_week = ["First"]
    retention_monthly_days = ["Sunday"]

    retention_yearly       = 1
    retention_yearly_month = ["January"]
    retention_yearly_week  = ["First"]
    retention_yearly_days  = ["Sunday"]
  }
}

# Protected VMs - Add your Windows VMs here for backup
# Use the vm_key to reference VMs from the windows_vms variable
protected_vms = {
  vm1 = {
    rsv_resource_group_name = "rg-lnt-eip-aks-nonprd-uaen-01"
    rsv_vault_name          = "rsv-lnt-eip-nonprd-uaen-01"
    vm_key                  = "win-vm1"  # References windows_vms.win-vm1
    backup_policy_key       = "policy1"
  }
  # Add more VMs as needed by referencing their keys:
  # vm2 = {
  #   rsv_resource_group_name = "rg-lnt-eip-aks-nonprd-uaen-01"
  #   rsv_vault_name          = "rsv-lnt-eip-nonprd-uaen-01"
  #   vm_key                  = "win-vm2"  # References windows_vms.win-vm2
  #   backup_policy_key       = "policy1"
  # }
}



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
      ra3 = {
        role_definition_name = "Private DNS Zone Contributor"
        scope_type           = "private_dns_zone"
        scope                = "/subscriptions/2bb0667b-d883-4406-b19a-a3083ba05bd8/resourceGroups/rg-hub-dns-uaenorth/providers/Microsoft.Network/privateDnsZones/privatelink.uaenorth.azmk8s.io"
      }
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
    resource_group_name = "rg-lnt-eip-nonprd-uaen-01"
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
  aks1 = {
    name                                = "aks-lnt-eip-nonprd-uaen-01"
    resource_group_name                 = "rg-lnt-eip-aks-nonprd-uaen-01"
    location                            = "UAE North"
    dns_prefix                          = "aks-lnt-eip-nonprd-uaen-01"
    sku_tier                            = "Free"
    private_cluster_enabled             = true
    private_cluster_public_fqdn_enabled = false
    azure_policy_enabled                = false
    only_critical_addons_enabled        = true
    node_vm_size                        = "Standard_D2s_v3"
    node_os_disk_size_gb                = 100
    auto_scaling_enabled                = false
    aks_node_count                      = 1
    max_pods                            = 64
    enable_azure_ad                     = true
    user_assigned_managed_identity      = "kubernetes-lnt-eip-aks-nonprd-uaen-01"
    kubelet_identity                    = "kubelet-lnt-eip-aks-kubelet-nonprd-uaen-01"
    tags = {
      "Application Owner"    = "IT"
      "Business Criticality" = "Essential"
      "Environment"          = "Integrations"
    }

    node_pools = {
      np1 = {
        name                        = "unp1"
        temporary_name_for_rotation = "unp1temp"
        zones                       = [1, 2, 3]
        vm_size                     = "Standard_D2s_v3"
        max_count                   = 1
        max_pods                    = 64
        min_count                   = 1
        os_disk_size_gb             = 30
        os_disk_type                = "Ephemeral"
        priority                    = "Regular"
        spot_max_price              = null
        eviction_policy             = null
        vnet_subnet_id              = "vn1.sn2" # ND subnet key for AKS node pool
        node_labels = {
          "nodepool" = "userpool1"
        }
        node_taints = []
        tags = {
          "Application Owner"    = "IT"
          "Business Criticality" = "Essential"
          "Environment"          = "Integrations"
        }
      },
    }
  }

}

admin_group_object_ids = ["1c1de890-2a46-4597-8f88-0e26161cf9a2"]

windows_vms = {
  win-vm1 = {
    resource_group_name = "rg-lnt-eip-vm-nonprd-uaen-01"
    location            = "UAE North"
    subnet_id           = "vn1.sn5" # snet-lnt-eip-vm-nonprd-uaen-01
    vm_name             = "vm-lnt-wvm1-np1"
    vm_size             = "Standard_B2s"
    admin_username      = "winadmin"
    os_disk_name        = "osdisk-lnt-wvm1-np1"
    enable_public_ip    = true # Enable public IP for RDP access
    tags = {
      "Application Owner"    = "IT"
      "Business Criticality" = "Essential"
      "Environment"          = "Integration"
      "Purpose"              = "Jump Box for AKS Private Cluster Access"
    }
  }
}

windows_vm_custom_data_script = null

win_vm_extensions = {
  aad_login = {
    publisher            = "Microsoft.Azure.ActiveDirectory"
    type                 = "AADLoginForWindows"
    type_handler_version = "1.0"
  }
  azure_monitor = {
    publisher            = "Microsoft.Azure.Monitor"
    type                 = "AzureMonitorWindowsAgent"
    type_handler_version = "1.11"
  }
}

win_vm_source_image_reference = {
  publisher = "MicrosoftWindowsServer"
  offer     = "WindowsServer"
  sku       = "2022-datacenter-azure-edition"
  version   = "latest"
}

os_disk = {
  storage_account_type = "Standard_LRS"
  caching              = "ReadWrite"
  disk_size_gb         = 127 # Minimum for Windows Server 2022
}

data_disk = {
  storage_account_type = "Standard_LRS"
  disk_size_gb         = 4 # Minimum allowed: 4 GB
  caching              = "ReadWrite"
  lun                  = 0
}

win_vm = {
  enable_vm_extension = false
  extension_command   = ""
}

automation_accounts = {
  aa1 = {
    name                = "aa-lnt-eip-nonprd-uaen-01"
    resource_group_name = "rg-lnt-eip-aks-nonprd-uaen-01"
    location            = "UAE North"
    sku_name            = "Basic"
    tags = {
      "Application Owner"    = "IT"
      "Business Criticality" = "Essential"
      "Environment"          = "Integrations"
    }
  }
}

# Runbook to stop AKS and VM
automation_runbooks = {
  stop_resources = {
    name                   = "Stop-AKS-and-VM"
    automation_account_key = "aa1"
    resource_group_name    = "rg-lnt-eip-aks-nonprd-uaen-01"
    location               = "UAE North"
    runbook_type           = "PowerShell"
    log_verbose            = true
    log_progress           = true
    description            = "Stop AKS cluster and Windows VM to save costs"
    script_path            = "./modules/automation-account/scripts/Stop-AKS-and-VM.ps1"
  }

  start_resources = {
    name                   = "Start-AKS-and-VM"
    automation_account_key = "aa1"
    resource_group_name    = "rg-lnt-eip-aks-nonprd-uaen-01"
    location               = "UAE North"
    runbook_type           = "PowerShell"
    log_verbose            = true
    log_progress           = true
    description            = "Start AKS cluster and Windows VM"
    script_path            = "./modules/automation-account/scripts/Start-AKS-and-VM.ps1"
  }
}


# Schedule to stop resources every day at 11:59 PM
automation_schedules = {
  stop_schedule = {
    name                   = "Stop-Resources-Daily-2359"
    automation_account_key = "aa1"
    resource_group_name    = "rg-lnt-eip-aks-nonprd-uaen-01"
    frequency              = "Day"
    interval               = 1
    timezone               = "Asia/Dubai"
    start_time             = "2025-11-23T23:59:00+04:00"  # 11:59 PM UAE daily
    description            = "Stop AKS and VM every day at 11:59 PM"
    week_days              = null
  }

  # Uncomment to enable automatic start schedule
  # start_schedule = {
  #   name                   = "Start-Resources-8AM"
  #   automation_account_key = "aa1"
  #   resource_group_name    = "rg-lnt-eip-aks-nonprd-uaen-01"
  #   frequency              = "Day"
  #   interval               = 1
  #   timezone               = "Asia/Dubai"
  #   start_time             = "2025-11-23T08:00:00+04:00"  # 8 AM UAE daily
  #   description            = "Start AKS and VM every day at 8 AM"
  #   week_days              = null
  # }
}

# Link runbooks to schedules
# Note: Azure requires parameter names in lowercase due to a bug in runbook implementation
automation_job_schedules = {
  stop_job = {
    automation_account_key = "aa1"
    resource_group_name    = "rg-lnt-eip-aks-nonprd-uaen-01"
    runbook_name           = "Stop-AKS-and-VM"
    schedule_name          = "Stop-Resources-Daily-2359"
    parameters = {
      aksresourcegroup = "rg-lnt-eip-aks-nonprd-uaen-01"
      aksclustername   = "aks-lnt-eip-nonprd-uaen-01"
      vmresourcegroup  = "rg-lnt-eip-vm-nonprd-uaen-01"
      vmname           = "vm-lnt-wvm1-np1"
    }
  }

  # Uncomment to enable automatic start job schedule
  # start_job = {
  #   automation_account_key = "aa1"
  #   resource_group_name    = "rg-lnt-eip-aks-nonprd-uaen-01"
  #   runbook_name           = "Start-AKS-and-VM"
  #   schedule_name          = "Start-Resources-8AM"
  #   parameters = {
  #     aksresourcegroup = "rg-lnt-eip-aks-nonprd-uaen-01"
  #     aksclustername   = "aks-lnt-eip-nonprd-uaen-01"
  #     vmresourcegroup  = "rg-lnt-eip-vm-nonprd-uaen-01"
  #     vmname           = "vm-lnt-wvm1-np1"
  #   }
  # }
}

# Role assignments for Automation Account managed identity
automation_role_assignments = {
  aks_rg_contributor = {
    automation_account_key = "aa1"
    role_definition_name   = "Contributor"
    scope                  = "/subscriptions/43731ed3-ead8-4406-b85d-18e966dfdb9f/resourceGroups/rg-lnt-eip-aks-nonprd-uaen-01"
  }
  vm_rg_contributor = {
    automation_account_key = "aa1"
    role_definition_name   = "Contributor"
    scope                  = "/subscriptions/43731ed3-ead8-4406-b85d-18e966dfdb9f/resourceGroups/rg-lnt-eip-vm-nonprd-uaen-01"
  }
}
