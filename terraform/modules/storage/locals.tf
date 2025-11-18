locals {
  resource_group = regex("^/subscriptions/[^/]+/resourceGroups/(?P<name>[^/]+)$", var.resource_group_id)
}
