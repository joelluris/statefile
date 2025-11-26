# Azure Container Registry (ACR) Module

## Overview

This module deploys Azure Container Registry with optional private endpoint support for secure container image storage and distribution to AKS.

## Architecture

```
webMethods.io (External SaaS)
        ↓
    Internet
        ↓
Your ACR (acrlnteipnonprd01)
        ↓
Your AKS pulls images
```

## Pushing Images from webMethods.io to ACR

### Option 1: Direct Push via ACR Admin Credentials (Simplest)

**1. Enable ACR Admin User:**
```hcl
# In int.tfvars
acr = {
  acr1 = {
    name                          = "acrlnteipnonprd01"
    sku                           = "Basic"
    admin_enabled                 = true  # Enable admin user
    public_network_access_enabled = true
    ...
  }
}
```

**2. Get ACR Credentials:**
```powershell
az acr credential show --name acrlnteipnonprd01 --resource-group rg-lnt-eip-nonprd-uaen-01
```

Returns:
```json
{
  "username": "acrlnteipnonprd01",
  "password": "xxxxxxxxxxxx",
  "password2": "yyyyyyyyyyyy"
}
```

**3. Push from webMethods.io:**
```bash
docker login acrlnteipnonprd01.azurecr.io -u acrlnteipnonprd01 -p <password>
docker tag webmethods-integration:v1 acrlnteipnonprd01.azurecr.io/webmethods-integration:v1
docker push acrlnteipnonprd01.azurecr.io/webmethods-integration:v1
```

**Pros:** ✅ Simple, works immediately  
**Cons:** ⚠️ Admin credentials have full registry access

---

### Option 2: Service Principal (Recommended for Production) ⭐

**1. Create Service Principal:**
```powershell
# Create SP
$sp = az ad sp create-for-rbac --name "sp-webmethods-acr-push" --skip-assignment

# Get ACR ID
$acrId = az acr show --name acrlnteipnonprd01 --query id -o tsv

# Grant AcrPush role (push only, no pull/delete)
az role assignment create --assignee $sp.appId --role AcrPush --scope $acrId
```

**2. Get Credentials:**
```json
{
  "appId": "xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "password": "your-client-secret",
  "tenant": "7d1a04ec-981a-405a-951b-dd2733120e4c"
}
```

**3. Push from webMethods.io:**
```bash
docker login acrlnteipnonprd01.azurecr.io -u <appId> -p <password>
docker push acrlnteipnonprd01.azurecr.io/webmethods-integration:v1
```

**Pros:** ✅ Limited permissions (push only), ✅ Can revoke without affecting ACR  
**Cons:** Requires service principal management

---

### Option 3: Via Jump Box / Developer VM

Use your existing VMs as intermediaries for manual image pushes.

**On Windows Jump Box (`vm-lnt-wvm1-np1`):**
```powershell
# Install Docker Desktop (if not installed)
winget install Docker.DockerDesktop

# Login to ACR
az acr login --name acrlnteipnonprd01

# Pull from webMethods.io
docker pull webmethods.io/your-integration:v1

# Retag for ACR
docker tag webmethods.io/your-integration:v1 acrlnteipnonprd01.azurecr.io/webmethods-integration:v1

# Push to ACR
docker push acrlnteipnonprd01.azurecr.io/webmethods-integration:v1
```

**On Linux VM (`vm-lnt-ubn1-np1`):**
```bash
# Install Docker
sudo apt-get update && sudo apt-get install docker.io -y

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Login to ACR
az acr login --name acrlnteipnonprd01

# Pull, tag, push
docker pull webmethods.io/your-integration:v1
docker tag webmethods.io/your-integration:v1 acrlnteipnonprd01.azurecr.io/webmethods-integration:v1
docker push acrlnteipnonprd01.azurecr.io/webmethods-integration:v1
```

**Helper Script for Linux VM:**
```bash
#!/bin/bash
# /usr/local/bin/push-to-acr.sh
# Usage: push-to-acr.sh webmethods-integration v1.0

IMAGE_NAME=$1
TAG=$2
ACR_NAME="acrlnteipnonprd01"

echo "Logging into ACR..."
az acr login --name $ACR_NAME

echo "Pulling from webMethods.io..."
docker pull webmethods.io/$IMAGE_NAME:$TAG

echo "Tagging for ACR..."
docker tag webmethods.io/$IMAGE_NAME:$TAG $ACR_NAME.azurecr.io/$IMAGE_NAME:$TAG

echo "Pushing to ACR..."
docker push $ACR_NAME.azurecr.io/$IMAGE_NAME:$TAG

echo "✅ Image available: $ACR_NAME.azurecr.io/$IMAGE_NAME:$TAG"
```

**Pros:** ✅ Uses existing infrastructure, ✅ Can use AAD authentication  
**Cons:** Manual process (can be automated via scripts)

---

### Option 4: Managed Identity (Most Secure for Azure Resources)

Grant ACR push permissions to your User-Assigned Managed Identity.

**1. Update Terraform Configuration:**
```hcl
# In int.tfvars
user_assigned_managed_identity = {
  workload_identity = {
    name     = "uami-lnt-eip-nonprd-uaen-01"
    rg_name  = "rg-lnt-eip-aks-nonprd-uaen-01"
    location = "UAE North"
    role_assignments = {
      ra1 = {
        role_definition_name = "AcrPush"
        scope_type           = "azure_container_registry"
        scope                = "acr1"  # Your ACR key
      }
      # ... other assignments
    }
  }
}
```

**2. From VM with managed identity:**
```bash
# Login using managed identity (no credentials needed!)
az login --identity

# Login to ACR
az acr login --name acrlnteipnonprd01

# Push images
docker push acrlnteipnonprd01.azurecr.io/webmethods-integration:v1
```

**Pros:** ✅ No credentials stored, ✅ Most secure, ✅ Automatic authentication  
**Cons:** Only works from Azure VMs/AKS

---

## Recommended Setup

### For External CI/CD (webMethods.io):
- **Use Option 2 (Service Principal)** - Secure, external-compatible, revocable

### For Developer Workflows:
- **Use Option 3 (VMs)** - Developers connect via Jump Box, use AAD auth

### For Automated VM Tasks:
- **Use Option 4 (Managed Identity)** - Most secure, no credential management

## ACR SKU Comparison

| Feature | Basic | Standard | Premium |
|---------|-------|----------|---------|
| **Monthly Cost (UAE North)** | ~$16/month | ~$67/month | ~$167/month |
| **Storage Included** | 10 GB | 100 GB | 500 GB |
| **Webhooks** | 2 | 10 | 500 |
| **Geo-replication** | ❌ | ❌ | ✅ |
| **Private Endpoints** | ❌ | ❌ | ✅ |
| **Network Rules** | ❌ | ❌ | ✅ |
| **Zone Redundancy** | ❌ | ❌ | ✅ |

**Current Setup:** Basic SKU with public access for dev/test cost optimization.

## Security Considerations

- **Public Access Enabled**: ACR is accessible from internet (secured by authentication)
- **Admin Credentials**: Disabled by default (recommended for production)
- **RBAC**: Use Service Principal or Managed Identity for granular permissions
- **Private Endpoints**: Available with Premium SKU if needed for production

## Common Commands

```bash
# List images in ACR
az acr repository list --name acrlnteipnonprd01

# Show tags for an image
az acr repository show-tags --name acrlnteipnonprd01 --repository webmethods-integration

# Delete an image
az acr repository delete --name acrlnteipnonprd01 --image webmethods-integration:v1

# Pull image to local
docker pull acrlnteipnonprd01.azurecr.io/webmethods-integration:v1
```

## AKS Integration

Your AKS cluster pulls images from ACR using the kubelet managed identity:

```yaml
# In Kubernetes deployment
spec:
  containers:
  - name: app
    image: acrlnteipnonprd01.azurecr.io/webmethods-integration:v1
```

The kubelet identity (`kubelet-lnt-eip-aks-kubelet-nonprd-uaen-01`) should have `AcrPull` role on the ACR.

## Troubleshooting

**Issue: "unauthorized: authentication required"**
```bash
# Solution: Login to ACR
az acr login --name acrlnteipnonprd01
```

**Issue: "manifest unknown"**
```bash
# Solution: Check image exists
az acr repository show-tags --name acrlnteipnonprd01 --repository your-image
```

**Issue: AKS can't pull image**
```bash
# Solution: Grant AcrPull to kubelet identity
az role assignment create \
  --assignee <kubelet-identity-client-id> \
  --role AcrPull \
  --scope /subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.ContainerRegistry/registries/acrlnteipnonprd01
```

## Module Outputs

- `acr_ids`: Map of ACR resource IDs
- `acr_login_servers`: Map of ACR login server URLs
- `acr_details`: Complete details including ID, name, login_server, SKU

#########################################################