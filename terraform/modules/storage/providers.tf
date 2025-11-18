terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.5"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~>1.15"
    }
  }
}
