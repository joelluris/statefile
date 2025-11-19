<<<<<<< HEAD
# VirtualNetwork Module

This module creates Azure Virtual Networks with subnets, NSGs, route tables, and optional VNet peering.

## Troubleshooting Guide

### Backend Authentication Issues (Resolved)

#### Problem 1: Backend Configuration Error
**Error Message:**
```
Error: One of `access_key`, `sas_token`, `use_azuread_auth` and `resource_group_name` must be specified
```

**Root Cause:**
The module had TWO places trying to authenticate with Azure Storage for Terraform state:
1. **Main backend** (`backend.tf`) - Stores current environment's state
2. **Remote state data source** (in this module) - Reads shared environment's state for VNet peering

**Solution:**
Added `use_azuread_auth = true` to both locations:

```terraform
# In main backend.tf
terraform {
  backend "azurerm" {
    use_azuread_auth = true  # ✅ Added this
  }
}

# In module data source (main..tf line 123)
data "terraform_remote_state" "tfstate_shared" {
  backend = "azurerm"  
  config = {
    resource_group_name  = var.tf_storage_resource_group
    storage_account_name = var.tf_storage_account_name
    container_name       = var.tf_container_name
    key                  = "shared.tfstate"
    use_azuread_auth     = true  # ✅ Changed from access_key to this
  }
}
```

#### Problem 2: Empty Container Name Error
**Error Message:**
```
Error: error loading the remote state: `containerName` cannot be an empty string
```

**Root Cause:**
The remote state data source was being evaluated even when VNet peering was disabled (`enable_vnet_peering_remote = false`). Terraform data sources are evaluated regardless of whether their outputs are used.

**Solution:**
Added a `count` condition to conditionally create the data source only when peering is enabled:

```terraform
# Before (always evaluated)
data "terraform_remote_state" "tfstate_shared" {
  backend = "azurerm"
  config = { ... }
}

# After (conditional evaluation)
data "terraform_remote_state" "tfstate_shared" {
  count   = var.enable_vnet_peering_remote ? 1 : 0  # ✅ Added count
  backend = "azurerm"
  config = { ... }
}

# Updated locals to handle data source as array
locals {
  shared_vnet_ids = var.enable_vnet_peering_remote && length(data.terraform_remote_state.tfstate_shared) > 0 ? {
    for k, v in data.terraform_remote_state.tfstate_shared[0].outputs.vnet_details_output : v.name => v.id
  } : {}  # ✅ Returns empty map when peering disabled
}
```

### Additional Issues Resolved

#### Problem 3: Undeclared Variable Warnings
**Error Message:**
```
Warning: Value for undeclared variable
The root module does not declare a variable named "BackupPolicy"
```

**Solution:**
Added `default = {}` to optional variables in `variables.tf`:
```terraform
variable "BackupPolicy" {
  ...
  default = {}  # ✅ Makes variable optional
}
```

#### Problem 4: Unused Variables in tfvars
**Solution:**
Commented out variables for modules that aren't being used yet (BackupPolicy, Azure_Policy, bastion_*, etc.)

## Usage

### Basic VNet without Peering
```terraform
module "VirtualNetwork" {
  source = "./modules/VirtualNetwork"
  
  enable_vnet_peering_remote = false  # Disable peering
  vnets                      = var.vnets
  nsg_snet                   = var.nsg_snet
  routetables               = var.routetables
  # ... other required variables
}
```

### VNet with Peering to Shared Environment
```terraform
module "VirtualNetwork" {
  source = "./modules/VirtualNetwork"
  
  enable_vnet_peering_remote = true   # Enable peering
  vnet_peering_remote        = var.vnet_peering_remote
  
  # Required for remote state access
  tf_storage_resource_group  = "rg-tfstate-mgmt"
  tf_storage_account_name    = "sttfstatemgmt"
  tf_container_name          = "tfstate"
  
  # ... other required variables
}
```

## Key Lessons Learned

1. **Data sources are always evaluated** - Use `count` or `for_each` to conditionally create them
2. **Backend authentication must match** - If main backend uses Azure AD auth, remote state data sources should too
3. **Variables need defaults** - Optional variables should have `default = {}` or similar to avoid "required variable" errors
4. **Pipeline variables must be populated** - Empty strings in backend config cause cryptic errors

## Date: November 19, 2025
=======
# VirtualNetwork Module

This module creates Azure Virtual Networks with subnets, NSGs, route tables, and optional VNet peering.

## Troubleshooting Guide

### Backend Authentication Issues (Resolved)

#### Problem 1: Backend Configuration Error
**Error Message:**
```
Error: One of `access_key`, `sas_token`, `use_azuread_auth` and `resource_group_name` must be specified
```

**Root Cause:**
The module had TWO places trying to authenticate with Azure Storage for Terraform state:
1. **Main backend** (`backend.tf`) - Stores current environment's state
2. **Remote state data source** (in this module) - Reads shared environment's state for VNet peering

**Solution:**
Added `use_azuread_auth = true` to both locations:

```terraform
# In main backend.tf
terraform {
  backend "azurerm" {
    use_azuread_auth = true  # ✅ Added this
  }
}

# In module data source (main..tf line 123)
data "terraform_remote_state" "tfstate_shared" {
  backend = "azurerm"  
  config = {
    resource_group_name  = var.tf_storage_resource_group
    storage_account_name = var.tf_storage_account_name
    container_name       = var.tf_container_name
    key                  = "shared.tfstate"
    use_azuread_auth     = true  # ✅ Changed from access_key to this
  }
}
```

#### Problem 2: Empty Container Name Error
**Error Message:**
```
Error: error loading the remote state: `containerName` cannot be an empty string
```

**Root Cause:**
The remote state data source was being evaluated even when VNet peering was disabled (`enable_vnet_peering_remote = false`). Terraform data sources are evaluated regardless of whether their outputs are used.

**Solution:**
Added a `count` condition to conditionally create the data source only when peering is enabled:

```terraform
# Before (always evaluated)
data "terraform_remote_state" "tfstate_shared" {
  backend = "azurerm"
  config = { ... }
}

# After (conditional evaluation)
data "terraform_remote_state" "tfstate_shared" {
  count   = var.enable_vnet_peering_remote ? 1 : 0  # ✅ Added count
  backend = "azurerm"
  config = { ... }
}

# Updated locals to handle data source as array
locals {
  shared_vnet_ids = var.enable_vnet_peering_remote && length(data.terraform_remote_state.tfstate_shared) > 0 ? {
    for k, v in data.terraform_remote_state.tfstate_shared[0].outputs.vnet_details_output : v.name => v.id
  } : {}  # ✅ Returns empty map when peering disabled
}
```

### Additional Issues Resolved

#### Problem 3: Undeclared Variable Warnings
**Error Message:**
```
Warning: Value for undeclared variable
The root module does not declare a variable named "BackupPolicy"
```

**Solution:**
Added `default = {}` to optional variables in `variables.tf`:
```terraform
variable "BackupPolicy" {
  ...
  default = {}  # ✅ Makes variable optional
}
```

#### Problem 4: Unused Variables in tfvars
**Solution:**
Commented out variables for modules that aren't being used yet (BackupPolicy, Azure_Policy, bastion_*, etc.)

## Usage

### Basic VNet without Peering
```terraform
module "VirtualNetwork" {
  source = "./modules/VirtualNetwork"
  
  enable_vnet_peering_remote = false  # Disable peering
  vnets                      = var.vnets
  nsg_snet                   = var.nsg_snet
  routetables               = var.routetables
  # ... other required variables
}
```

### VNet with Peering to Shared Environment
```terraform
module "VirtualNetwork" {
  source = "./modules/VirtualNetwork"
  
  enable_vnet_peering_remote = true   # Enable peering
  vnet_peering_remote        = var.vnet_peering_remote
  
  # Required for remote state access
  tf_storage_resource_group  = "rg-tfstate-mgmt"
  tf_storage_account_name    = "sttfstatemgmt"
  tf_container_name          = "tfstate"
  
  # ... other required variables
}
```

## Key Lessons Learned

1. **Data sources are always evaluated** - Use `count` or `for_each` to conditionally create them
2. **Backend authentication must match** - If main backend uses Azure AD auth, remote state data sources should too
3. **Variables need defaults** - Optional variables should have `default = {}` or similar to avoid "required variable" errors
4. **Pipeline variables must be populated** - Empty strings in backend config cause cryptic errors

## Date: November 19, 2025
>>>>>>> 78e5aa15149f657fbc54cda3e30a9d0096cf7dea
