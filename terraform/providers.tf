terraform {
  required_version = "~> 1.13"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.53"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "2.7"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "3.6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1.0"
    }
  }

  backend "local" {
    path = "terraform.tfstate"
  }
}
provider "azurerm" {
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  features {}
}

provider "azuread" {
  tenant_id       = var.tenant_id
}

# provider "azurerm" {
#   resource_provider_registrations = "none"
#   alias                           = "LUNATE-SHARED_SERVICES"
#   subscription_id                 = "8041dff6-8186-4b97-9b32-365b16d0b28b"
#   features {}
# }

provider "azurerm" {
  resource_provider_registrations = "none"
  alias                           = "connectivity"
  subscription_id                 = "2bb0667b-d883-4406-b19a-a3083ba05bd8"
  features {}
}
