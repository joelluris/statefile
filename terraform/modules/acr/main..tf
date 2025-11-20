terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

# Azure Container Registry with Private Endpoint
resource "azurerm_container_registry" "acr" {
  for_each                      = var.acr
  name                          = each.value.name
  location                      = each.value.location
  resource_group_name           = each.value.resource_group_name
  sku                           = each.value.sku
  admin_enabled                 = each.value.admin_enabled
  public_network_access_enabled = false  # Private only
  
  # Network rule set for additional security
  network_rule_set {
    default_action = "Deny"
  }

  # Enable features based on SKU
  dynamic "retention_policy" {
    for_each = each.value.sku == "Premium" ? [1] : []
    content {
      days    = 7
      enabled = true
    }
  }

  tags = each.value.tags
}

# Private Endpoint for ACR
resource "azurerm_private_endpoint" "acr_pe" {
  for_each            = var.acr
  name                = "pe-${each.value.name}"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-${each.value.name}"
    private_connection_resource_id = azurerm_container_registry.acr[each.key].id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }

  private_dns_zone_group {
    name                 = "pdz-group-${each.value.name}"
    private_dns_zone_ids = [var.private_dns_zone_ids["acr"]]
  }

  tags = each.value.tags
}
