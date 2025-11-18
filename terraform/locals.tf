locals {
  project_code                 = var.project_code
  environment                  = var.environment
  location                     = var.location
  workloads                    = var.workloads
  resource_name_sequence_start = var.resource_name_sequence_start

  tags = merge(var.tags, {
    Environment = var.environment
  })
}
