✅ Corrected Subnet Allocation in 10.6.0.0/16:
Subnet	CIDR	        IP Range	# of IPs	    Usage
aks	    10.6.0.0/24	    10.6.0.0 -  10.6.0.255	    256	AKS system nodes
node	10.6.2.0/23	    10.6.2.0 -  10.6.3.255	    512	AKS worker nodes
pod	    10.6.16.0/20	10.6.16.0 - 10.6.31.255	    4,096	AKS pod IPs
mft	    10.6.32.0/28	10.6.32.0 - 10.6.32.15	    16	MFT service

/23 subnets must start on even boundaries (0, 2, 4, 6, 8...)
/20 subnets must start on boundaries divisible by 16 (0, 16, 32, 48...)
No overlaps, properly aligned, and leaves room for expansion

# AKS Network mode
The error indicates that you cannot use network_plugin_mode = "overlay" together with a separate pod_subnet_id. When using Azure CNI Overlay mode, pods get IPs from an internal overlay network, not from a dedicated subnet.

You have two options:

Option 1: Remove pod_subnet_id (Use Overlay without dedicated pod subnet)
Option 2: Use standard Azure CNI without overlay mode (requires pod subnet)

Let me check your current AKS configuration:

Read main.tf, lines 50 to 80

Read main.tf, lines 93 to 108

I see the issue. You're using Azure CNI Overlay mode, which doesn't support a separate pod subnet. I'll remove the overlay mode and use standard Azure CNI with the pod subnet you've allocated:

main.tf+5-3
Perfect! I've updated the network configuration to use standard Azure CNI which supports the pod subnet. Here's what changed:

✅ Fixed Network Configuration:
Changed from:

❌ Azure CNI Overlay mode (no pod subnet support)
Changed to:

✅ Azure CNI standard mode with dedicated pod subnet
✅ Added network_policy = "azure" for network policies
✅ Added service_cidr = "10.96.0.0/16" for Kubernetes services (internal cluster IPs)
✅ Added dns_service_ip = "10.96.0.10" for cluster DNS
Network Architecture:

Node IPs: Come from vnet_subnet_id (10.6.2.0/23) - 512 IPs
Pod IPs: Come from pod_subnet_id (10.6.16.0/20) - 4,096 IPs
Service IPs: Come from service_cidr (10.96.0.0/16) - internal only, doesn't conflict with VNet
DNS IP: 10.96.0.10 - must be within service_cidr range
This configuration gives you:

Dedicated IP space for pods (more scalable)
Network policies for pod-to-pod security
No conflicts with your VNet address space

# service_cidr = "10.96.0.0/16"
What it does: IP range for Kubernetes Services (internal cluster load balancers)
Important: This is NOT part of your VNet - it's cluster-internal only
Why separate: Services are virtual IPs that load-balance to pods
Example: When you create a Service, it gets an IP like 10.96.15.23 - this IP only works inside the cluster
Must NOT overlap with:
Your VNet address space (10.6.0.0/16)
Your pod subnet
Your node subnet
# dns_service_ip = "10.96.0.10"
What it does: IP address of the internal cluster DNS server (CoreDNS)
Requirement: MUST be within the service_cidr range
Why you need it: All pods use this DNS server to resolve service names
Example: When a pod needs to connect to my-database-service, it asks 10.96.0.10 which returns the service's cluster IP


┌─────────────────────────────────────────────────────────────┐
│ Cluster-Internal Network (NOT in VNet)                      │
│                                                             │
│  Service CIDR: 10.96.0.0/16                                 │
│  ├─ DNS Service: 10.96.0.10 (CoreDNS)                       │
│  ├─ Kubernetes API: 10.96.0.1                               │
│  └─ Your Services: 10.96.x.x (virtual load balancer IPs)    │
│                                                             │
└─────────────────────────────────────────────────────────────┘

# Variable Declarations
🙏🏾Parent Module (main.tf)
The parent module is where you orchestrate and call other modules. It:

🟡Declares variables.tf in main that come from your tfvars files
🟡Passes data to child modules
🟡Connects outputs from one module to inputs of another
🟡Transforms data before passing it to child modules

🙏🏾Child Module (modules/vnet-peering)
The child module is reusable code that does a specific job. It:

🟡Declares variables it needs from whoever calls it
🟡Doesn't know about your tfvars files
🟡Creates resources based on the inputs it receives
🟡Returns outputs for others to use
🟡Example from your vnet-peering/variables.tf:


# Errors



# Explicit var-file
cd C:\Users\joell\Documents\terraform-local-projects\acr-k8s-dev-micro

# Dev environment
terraform plan -var-file="environments/dev.tfvars"
terraform apply -var-file="environments/dev.tfvars"

# Staging/Test environment
terraform plan -var-file="environments/stg.tfvars"
terraform apply -var-file="environments/stg.tfvars"

# Production environment
terraform plan -var-file="environments/prd.tfvars"
terraform apply -var-file="environments/prd.tfvars"

# Run your plan and output it to a file
terraform plan -var-file="environments/dev.tfvars" -out=tfplan
terraform show -no-color tfplan > plan.txt
terraform apply -auto-approve -var-file="environments/nonprod.tfvars"
terraform destroy -var-file="environments/nonprod.tfvars" -auto-approve
#

terraform plan -var-file="environments/nonprod.tfvars" -out nonprod.tfplan
terraform show -no-color nonprod.tfplan > nonprod-plan.txt

#=================== searching a plan
terraform plan -var-file="environments/int.tfvars" | Select-String -Pattern "key_vault|keyvault" -Context 2,5

terraform plan -var-file="environments/int.tfvars" -out=tfplan.binary
terraform show tfplan.binary | Select-String -Pattern "azurerm_key_vault" -Context 3,10

# Find resources being created
terraform plan -var-file="environments/int.tfvars" | Select-String -Pattern "azurerm_key_vault.*will be created"

# Find all Key Vault related changes
terraform plan -var-file="environments/int.tfvars" | Select-String -Pattern "module\.KeyVault|azurerm_key_vault"