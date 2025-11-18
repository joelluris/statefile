terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      configuration_aliases = [ azurerm.LUNATE-SHARED_SERVICES ]
    }
  }
}
