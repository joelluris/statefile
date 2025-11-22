output "aks_ids" {
  description = "Map of AKS cluster IDs"
  value       = { for k, v in azurerm_kubernetes_cluster.aks : k => v.id }
}

output "aks_names" {
  description = "Map of AKS cluster names"
  value       = { for k, v in azurerm_kubernetes_cluster.aks : k => v.name }
}

output "aks_fqdns" {
  description = "Map of AKS cluster FQDNs"
  value       = { for k, v in azurerm_kubernetes_cluster.aks : k => v.fqdn }
}

output "aks_details" {
  description = "Complete details of all AKS clusters"
  value = {
    for k, v in azurerm_kubernetes_cluster.aks : k => {
      id   = v.id
      name = v.name
      fqdn = v.fqdn
      oidc_issuer_url = v.oidc_issuer_url
      kubelet_identity = v.kubelet_identity
    }
  }
}
