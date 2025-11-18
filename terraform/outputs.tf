# output "resource_names" {
#   description = "The names of resources created in this module"
#   value       = local.resource_names
# }

# output "resource_ids" {
#   value = {
#     resource_group = module.resource_group.resource_id
#     # virtual_network = module.virtual_network.resource_id
#     # aks_cluster     = module.aks_cluster.resource_id
#     # acr             = module.container_registry.resource_id
#   }
# }

# output "uami_id" {
#   description = "The principal ID of user assigned managed identities created in this module"
#   value = {
#     kubelet_user_assigned_managed  = module.user_assigned_managed_identity.identities["kubelet"].resource_id
#     node_user_assigned_managed     = module.user_assigned_managed_identity.identities["kubernetes"].resource_id
#     user_assigned_managed_identity = module.user_assigned_managed_identity.identities["uami"].resource_id
#   }
# }

