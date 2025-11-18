terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
    azuread = {
      source  = "hashicorp/azuread"
    }
    random = {
      source = "hashicorp/random"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
    }
    helm = {
      source  = "hashicorp/helm"
    }
  }
  backend "azurerm" {}
}
provider "azurerm" {
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  features {}
}

provider "azuread" {
  tenant_id       = var.tenant_id
}

provider "azurerm" {
  resource_provider_registrations = "none"
  alias                           = "LUNATE-SHARED_SERVICES"
  subscription_id                 = "8041dff6-8186-4b97-9b32-365b16d0b28b"
  features {}
}
