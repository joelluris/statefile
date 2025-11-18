terraform {
  backend "azurerm" {
    # Partial configuration - remaining values provided via backend.tfvars
    use_azuread_auth = true
  }
}
