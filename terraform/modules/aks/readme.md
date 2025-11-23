{
  name            = "web02"
  zones           = [2]
  vm_size         = "Standard_D4ads_v5"
  os_disk_size_gb = 150
  os_disk_type    = "Ephemeral"
  node_labels = {
    "kubernetes.azure.com/scalesetpriority" = "spot"
  }
  node_taints = [
    "kubernetes.azure.com/scalesetpriority=spot:NoSchedule",
  ]
  min_count       = 0
  max_count       = 1
  max_pods        = 64
  priority        = "Spot"
  spot_max_price  = -1
  eviction_policy = "Delete"
  node_subnet_id  = module.network.subnet_id["2"]
  pod_subnet_id   = module.network.subnet_id["1"]
},

name = "web02": Node pool identifier
# zones = [2]: Deploys in Azure Availability Zone 2 (high availability, fault isolation)
vm_size = "Standard_D4ads_v5": AMD-based VM with 4 vCPUs, 16GB RAM (cost-effective for workloads)

Storage Configuration
os_disk_size_gb = 150: 150GB OS disk
# os_disk_type = "Ephemeral":
Uses local VM storage (not Azure managed disk)
Pros: Faster I/O, no extra disk cost, better performance
Cons: Data lost on VM deallocation/deletion (fine for stateless workloads)
Perfect for Spot instances since they're ephemeral anyway
Spot Instance Configuration (Cost Optimization)

# priority = "Spot": Uses Azure Spot VMs (up to 90% cheaper than regular VMs)
# spot_max_price = -1: Pay up to regular price (won't be evicted due to price)
# eviction_policy = "Delete": When evicted, VM is deleted (not just deallocated)

np1 = {
    name                        = "unp1"
    temporary_name_for_rotation = "unp1temp"
    zones                       = [1]
    vm_size                     = "Standard_D2s_v3"
    max_count                   = 1
    max_pods                    = 64
    min_count                   = 1
    os_disk_size_gb             = 30
    os_disk_type                = "Ephemeral"
    priority                    = "Spot"
    spot_max_price              = -1
    eviction_policy             = "Delete"
    vnet_subnet_id              = "vn1.sn2" # ND subnet key for AKS node pool
    node_labels = {
        "nodepool" = "usernodepool1"
    }
    node_taints = []
    tags = {
        "Application Owner"    = "IT"
        "Business Criticality" = "Essential"
        "Environment"          = "Integrations"
    }
},

Basic Configuration
name = "unp1": Node pool identifier (user node pool 1)
temporary_name_for_rotation = "unp1temp": Temporary name used during node pool upgrades/rotations (blue-green deployment pattern)
zones = [1]: Deploys only in Availability Zone 1 (single zone for cost savings)
vm_size = "Standard_D2s_v3": 2 vCPUs, 8GB RAM, general-purpose VM
Autoscaling Configuration
min_count = 1: Always keep at least 1 node running
max_count = 1: Maximum 1 node (fixed size, no autoscaling)
max_pods = 64: Up to 64 pods per node
⚠️ Important: With min_count = max_count = 1, autoscaling is effectively disabled - you'll always have exactly 1 node.

Storage Configuration
os_disk_size_gb = 30: 30GB OS disk (small, cost-optimized)
os_disk_type = "Ephemeral":
Uses local VM storage (faster, no extra cost)
Data is lost when node is deleted/deallocated
Perfect for Spot instances since they're temporary anyway
Spot Instance Configuration (90% Cost Savings)
priority = "Spot": Uses Azure Spot VMs at huge discount
spot_max_price = -1: Pay up to regular price (won't be evicted due to price increases)
eviction_policy = "Delete": When evicted, node is deleted (not just stopped)


spec:
  tolerations:
  - key: "kubernetes.azure.com/scalesetpriority"
    operator: "Equal"
    value: "spot"
    effect: "NoSchedule"
    
kubernetes.azure.com/scalesetpriority=spot:NoSchedule
└─────────── key ──────────────┘ └value┘ └effect─┘