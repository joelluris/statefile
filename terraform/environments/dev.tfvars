# =============================
# Dev Environment Configuration
# =============================
#
# NOTE:
# - When running in Azure DevOps pipeline, tenant_id and subscription_id are appended automatically at runtime.
# - When running locally, uncomment and set these values, and set backend to local in providers.tf.
# - Comment these lines out if running in the pipeline.
#
# tenant_id       = "7d1a04ec-981a-405a-951b-dd2733120e4c" # <-- Uncomment for local use, comment for pipeline
# subscription_id = "43731ed3-ead8-4406-b85d-18e966dfdb9f" # <-- Uncomment for local use, comment for pipeline

# =============================
# General Configuration
# =============================
project_code                 = "lnt-eip"
environment                  = "nonprod"
location                     = "uaenorth"
resource_name_sequence_start = 1

workloads = ["aks", "vm"]

tags = {
  Project     = "lnt-eip"
  Environment = "nonprod"
  ManagedBy   = "Terraform"
  CostCenter  = "IT"
}

dns_servers = {
  dns_servers = ["8.8.8.8"]
}

# ==================================
# User Assigned Managed Identities
# ==================================
uami_names = {
  kubelet    = "id-lnt-eip-aks-kubelet-nonprod-01"
  kubernetes = "id-lnt-eip-aks-kubernetes-nonprod-01"
  workload   = "id-lnt-eip-aks-workload-nonprod-01"
}

# =============================
# VNet 1 Configuration (VM)
# =============================
address_space = ["10.5.0.0/20", "10.6.0.0/16"]

vnet1_name = "vnet-lnt-eip-vm-nonprod-01"

vnet1_subnets = {
  vm = {
    name                            = "snet-lnt-eip-vm-nonprod-01"
    address_prefixes                = ["10.5.0.0/28"]
    default_outbound_access_enabled = false
    nsg_key                         = "vm_jumpbox"
    delegation                      = []
    service_endpoints_with_location = [
      {
        service   = "Microsoft.KeyVault"
        locations = ["uaenorth"]
      }
    ]
  },
  # manage file transfer subnet
  mft = {
    name                            = "snet-lnt-eip-vm-lin-nonprod-01"
    address_prefixes                = ["10.5.0.16/28"]
    default_outbound_access_enabled = false
    nsg_key                         = "vm_management"
    delegation                      = []
    service_endpoints_with_location = []
  },
  # this is for postgresql subnet
  psql = {
    name                            = "snet-lnt-eip-psql-nonprod-01"
    address_prefixes                = ["10.5.0.32/28"]
    default_outbound_access_enabled = false
    nsg_key                         = "psql_db"
    delegation = [
      {
        name = "Microsoft.DBforPostgreSQL/flexibleServers"
        service_delegation = [
          {
            name    = "Microsoft.DBforPostgreSQL/flexibleServers"
            actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
          }
        ]
      }
    ]
    service_endpoints_with_location = [
      {
        service   = "Microsoft.Storage"
        locations = ["uaenorth"]
      }
    ]
  },

}

vnet1_nsgs = {
  "vm_jumpbox" = {
    name = "nsg-lnt-eip-vm-nonprod-01"
    rules = [
      {
        name                       = "AllowRDP"
        access                     = "Allow"
        destination_address_prefix = "*"
        destination_port_range     = "3389"
        direction                  = "Inbound"
        priority                   = 1000
        protocol                   = "Tcp"
        source_address_prefix      = "*"
        source_port_range          = "*"
      },
      {
        name                       = "AllowOutboundToAKS"
        access                     = "Allow"
        destination_address_prefix = "10.6.0.0/16"
        destination_port_range     = "*"
        direction                  = "Outbound"
        priority                   = 100
        protocol                   = "*"
        source_address_prefix      = "10.5.0.0/28"
        source_port_range          = "*"
      }
    ]
  }
  "vm_management" = {
    name = "nsg-lnt-eip-vm-mgmt-nonprod-01"
    rules = [
      {
        name                       = "AllowSSH"
        access                     = "Allow"
        destination_address_prefix = "*"
        destination_port_range     = "22"
        direction                  = "Inbound"
        priority                   = 1001
        protocol                   = "Tcp"
        source_address_prefix      = "*"
        source_port_range          = "*"
      }
    ]
  }
  "psql_db" = {
    name = "nsg-lnt-eip-psql-nonprod-01"
    rules = [
      {
        name                       = "AllowPostgreSQLFromAKS"
        access                     = "Allow"
        destination_address_prefix = "10.5.0.32/28"
        destination_port_range     = "5432"
        direction                  = "Inbound"
        priority                   = 100
        protocol                   = "Tcp"
        source_address_prefix      = "10.6.0.0/16"
        source_port_range          = "*"
      },
      {
        name                       = "AllowPostgreSQLFromVM"
        access                     = "Allow"
        destination_address_prefix = "10.5.0.32/28"
        destination_port_range     = "5432"
        direction                  = "Inbound"
        priority                   = 110
        protocol                   = "Tcp"
        source_address_prefix      = "10.5.0.0/28"
        source_port_range          = "*"
      }
    ]
  }
}

# =====================
# VNet 1 Route Tables
# =====================
vnet1_route_tables = {
  "firewall_routes" = {
    name                          = "rt-lnt-eip-vm-nonprod-01"
    disable_bgp_route_propagation = false
    routes = [
      {
        name                   = "route-to-firewall"
        address_prefix         = "0.0.0.0/0"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "10.0.5.1"
      }
    ]
  }
}

# =============================
# VNet 2 Configuration (AKS)
# =============================
vnet2_name = "vnet-lnt-eip-aks-nonprod-01"

vnet2_subnets = {
  aks = {
    name                            = "snet-lnt-eip-aks-nonprod-01"
    address_prefixes                = ["10.6.0.0/24"]
    default_outbound_access_enabled = false
    nsg_key                         = "aks_cluster"
    delegation                      = []
    service_endpoints_with_location = [
      {
        service   = "Microsoft.ContainerRegistry"
        locations = ["uaenorth"]
      }
    ]
  },
  node = {
    name                            = "snet-lnt-eip-nd-nonprod-01"
    address_prefixes                = ["10.6.2.0/23"]
    default_outbound_access_enabled = false
    delegation                      = []
    service_endpoints_with_location = []
  },
  pod = {
    name                            = "snet-lnt-eip-pd-nonprod-01"
    address_prefixes                = ["10.6.16.0/20"]
    default_outbound_access_enabled = false
    delegation                      = []
    service_endpoints_with_location = []
  },
  mft = {
    name                            = "snet-lnt-eip-mft-nonprod-01"
    address_prefixes                = ["10.6.32.0/28"]
    default_outbound_access_enabled = false
    nsg_key                         = "aks_cluster"
    delegation                      = []
    service_endpoints_with_location = []
  },
}

vnet2_nsgs = {
  "aks_cluster" = {
    name = "nsg-lnt-eip-aks-nonprod-01"
    rules = [
      {
        name                       = "AllowHTTPS"
        access                     = "Allow"
        destination_address_prefix = "*"
        destination_port_range     = "443"
        direction                  = "Inbound"
        priority                   = 1000
        protocol                   = "Tcp"
        source_address_prefix      = "*"
        source_port_range          = "*"
      },
      {
        name                       = "AllowHTTP"
        access                     = "Allow"
        destination_address_prefix = "*"
        destination_port_range     = "80"
        direction                  = "Inbound"
        priority                   = 1001
        protocol                   = "Tcp"
        source_address_prefix      = "*"
        source_port_range          = "*"
      },
      {
        name                       = "AllowFromJumpbox"
        access                     = "Allow"
        destination_address_prefix = "10.6.0.0/16"
        destination_port_range     = "*"
        direction                  = "Inbound"
        priority                   = 100
        protocol                   = "*"
        source_address_prefix      = "10.5.0.0/28"
        source_port_range          = "*"
      }
    ]
  }
}

# ========================================
# Azure Container Registry Configuration
# ========================================
acr_name = "acrlnteipnonprod01"

# =============================
# Key Vault Configuration
# =============================
key_vault_name           = "kv-lnt-eip-nonprod-01"
key_vault_key_name       = "des-key-nonprod"
disk_encryption_set_name = "des-lnt-eip-nonprod-01"

# =============================
# Hub VNet Configuration
# =============================
hub_vnet_name                = "vnet-hub-uaenorth"
hub_vnet_resource_group_name = "rg-hub-uaenorth"

# =============================
# AKS Configuration
# =============================
aks_name                 = "aks-lnt-eip-nonprod-01"
aks_dns_prefix           = "aks-lnt-eip-nonprod"
aks_linux_admin_username = "azureuser"

# Azure AD Admin Group Object IDs for AKS RBAC
admin_group_object_ids = [
  # Add your Azure AD group object IDs here
  # Example: "12345678-1234-1234-1234-123456789012"
]

# Note: Private DNS zones are fetched from the connectivity subscription via data sources
# See data.tf for the configuration

node_pools = [
  {
    name                        = "unp1"
    temporary_name_for_rotation = "unp1temp"
    zones                       = [1, 2, 3]
    vm_size                     = "Standard_D2s_v3"
    max_count                   = 3
    max_pods                    = 30
    min_count                   = 1
    os_disk_size_gb             = 30
    os_disk_type                = "Ephemeral"
    priority                    = "Regular"
    spot_max_price              = null
    eviction_policy             = null
    vnet_subnet_id              = "node" # References vnet2 subnet key
    pod_subnet_id               = "pod"  # References vnet2 subnet key
    node_labels = {
      "nodepool" = "userpool1"
    }
    node_taints = []
  }
]

# =============================
# Windows VM Configuration
# =============================
windows_vms = {
  win-vm1 = {
    vm_name        = "vm1-lnt-eip-win-np-01"
    vm_size        = "Standard_B2s"
    admin_username = "winadmin"
    os_disk_name   = "osdisk-vm-lnt-eip-win-np-01"
  }
  win-vm2 = {
    vm_name        = "vm2-lnt-eip-win-np-01"
    vm_size        = "Standard_B2s"
    admin_username = "winadmin"
    os_disk_name   = "osdisk-vm-lnt-eip-win-np-02"
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
  disk_size_gb         = 128
}

data_disk = {
  storage_account_type = "Standard_LRS"
  disk_size_gb         = 16
  caching              = "ReadWrite"
  lun                  = 0
}

win_vm = {
  enable_vm_extension = false
  extension_command   = ""
}


# =============================
# Linux VM Configuration
# =============================
linux_vms = {
  linux-vm1 = {
    vm_name        = "vm1-lnt-eip-linux-np-01"
    vm_size        = "Standard_B2s"
    admin_username = "azureuser"
    os_disk_name   = "osdisk-vm-lnt-eip-linux-np-01"
  }
  linux-vm2 = {
    vm_name        = "vm2-lnt-eip-linux-np-01"
    vm_size        = "Standard_B2s"
    admin_username = "azureuser"
    os_disk_name   = "osdisk-vm-lnt-eip-linux-np-02"
  }
}

linux_vm_custom_data_script = null

linux_vm_disable_password_authentication = true

# Generate SSH key with: ssh-keygen -t rsa -b 4096 -C "azureuser@example.com"
linux_vm_ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC... your-public-key-here"

linux_vm_extensions = {
  azure_monitor = {
    publisher            = "Microsoft.Azure.Monitor"
    type                 = "AzureMonitorLinuxAgent"
    type_handler_version = "1.29"
  }
}

linux_vm_source_image_reference = {
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-jammy"
  sku       = "22_04-lts-gen2"
  version   = "latest"
}

linux_os_disk = {
  storage_account_type = "Standard_LRS"
  caching              = "ReadWrite"
  disk_size_gb         = 30
}

linux_data_disk = {
  storage_account_type = "Standard_LRS"
  disk_size_gb         = 16
  caching              = "ReadWrite"
  lun                  = 0
}

# =============================
# PostgreSQL Configuration
# =============================
