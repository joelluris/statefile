# terraform {
#   required_version = "~> 1.13"

#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "4.53"
#       # configuration_aliases needs to be set if your providers.tf block in parent module
#       # has multiple azurerm provider configurations (with aliases).
#       configuration_aliases = [ azurerm.connectivity ]
#     }
#     azapi = {
#       source  = "Azure/azapi"
#       version = "2.7"
#     }
#     local = {
#       source  = "hashicorp/local"
#       version = "~> 2.5"
#     }
#     random = {
#       source  = "hashicorp/random"
#       version = "3.7.2"
#     }
#     azuread = {
#       source  = "hashicorp/azuread"
#       version = "3.6.0"
#     }
#   }
# }