# Azure DevOps Setup Guide

Complete guide for setting up Azure DevOps pipelines for this Terraform infrastructure project.

## 📋 Prerequisites

- Azure DevOps organization: `https://dev.azure.com/jlurisenterprise`
- Azure subscription(s) for dev, test, and production
- Repository synced to Azure DevOps Repos
- Self-hosted agent configured (WSL-Agent pool)

## 🔧 Initial Setup

### 1. Service Connections

Create service connections for each environment to authenticate with Azure.

**Steps:**

1. Navigate to **Project Settings** → **Service connections**
2. Click **New service connection** → **Azure Resource Manager**
3. Select **Service principal (automatic)**
4. Configure for each environment:

#### Dev Environment
- **Subscription**: Select your dev subscription
- **Service connection name**: `azure-dev-service-connection`
- **Grant access permission to all pipelines**: ☑️ (for initial setup)

#### Test/Staging Environment
- **Subscription**: Select your test subscription
- **Service connection name**: `azure-test-service-connection`
- **Grant access permission to all pipelines**: ☐ (restrict to specific pipelines)

#### Production Environment
- **Subscription**: Select your production subscription
- **Service connection name**: `azure-prod-service-connection`
- **Grant access permission to all pipelines**: ☐ (restrict to production pipeline only)
- **Description**: Production - requires approval

### 2. Environments

Set up Azure DevOps Environments for deployment tracking and approval gates.

**Steps:**

1. Navigate to **Pipelines** → **Environments**
2. Click **New environment**

#### Dev Environment
- **Name**: `dev`
- **Description**: Development environment - auto-deploy
- **Resource**: None (Kubernetes cluster can be added later)
- **Approvals and checks**: None

#### Test Environment
- **Name**: `test`
- **Description**: Test/Staging environment
- **Approvals and checks**: 
  - ☑️ **Approvals** (optional): Add your team lead
  - ☑️ **Branch control**: Restrict to `main` branch only

#### Production Environment
- **Name**: `production`
- **Description**: Production environment - requires approval
- **Approvals and checks**:
  - ☑️ **Approvals** (required): Add approvers (DevOps lead, Product owner)
  - ☑️ **Branch control**: Restrict to `main` branch only
  - ☑️ **Business hours**: Restrict deployments to business hours (optional)
  - ☑️ **Invoke Azure Function**: Add automated security/compliance checks (optional)

### 3. Agent Pool

Verify your self-hosted agent is configured and online.

**Steps:**

1. Navigate to **Organization Settings** → **Agent pools**
2. Click on **WSL-Agent** pool
3. Verify agent status:
   - **Agent**: Dell-Predator-G15-5530
   - **Status**: 🟢 Online
   - **Enabled**: ☑️ Yes
   - **Version**: v4.264.2 or later

**Grant pool access to project:**
1. Click **Security** tab
2. Add **Project Build Service** with **User** role
3. Add your project: `acr-k8s-dev-micro` → **User** role

### 4. Variable Groups

Create variable groups to store environment-specific variables securely.

**Steps:**

1. Navigate to **Pipelines** → **Library**
2. Click **+ Variable group**

#### Dev Variable Group
- **Variable group name**: `terraform-dev`
- **Variables**:
  - `ARM_CLIENT_ID`: (Service Principal ID)
  - `ARM_CLIENT_SECRET`: (Service Principal Secret) - 🔒 Secret
  - `ARM_SUBSCRIPTION_ID`: (Dev subscription ID)
  - `ARM_TENANT_ID`: (Azure AD tenant ID)
  - `TF_VAR_environment`: `dev`
- **Pipeline permissions**: Allow access to all pipelines

#### Test Variable Group
- **Variable group name**: `terraform-test`
- **Variables**:
  - `ARM_CLIENT_ID`: (Service Principal ID)
  - `ARM_CLIENT_SECRET`: (Service Principal Secret) - 🔒 Secret
  - `ARM_SUBSCRIPTION_ID`: (Test subscription ID)
  - `ARM_TENANT_ID`: (Azure AD tenant ID)
  - `TF_VAR_environment`: `test`
- **Pipeline permissions**: Restrict to specific pipelines

#### Prod Variable Group
- **Variable group name**: `terraform-prod`
- **Variables**:
  - `ARM_CLIENT_ID`: (Service Principal ID)
  - `ARM_CLIENT_SECRET`: (Service Principal Secret) - 🔒 Secret
  - `ARM_SUBSCRIPTION_ID`: (Prod subscription ID)
  - `ARM_TENANT_ID`: (Azure AD tenant ID)
  - `TF_VAR_environment`: `prod`
- **Pipeline permissions**: Restrict to production pipeline only

### 5. Azure Storage Accounts (Terraform State)

Create storage accounts for remote state management.

**Azure CLI Commands:**

```bash
# Login to Azure
az login

# Dev Environment
az group create --name rg-tfstate-dev-uaenorth-001 --location uaenorth
az storage account create \
  --name sttfstatedevuae001 \
  --resource-group rg-tfstate-dev-uaenorth-001 \
  --location uaenorth \
  --sku Standard_LRS \
  --encryption-services blob \
  --https-only true \
  --min-tls-version TLS1_2

az storage container create \
  --name tfstate \
  --account-name sttfstatedevuae001

# Test Environment
az group create --name rg-tfstate-test-uaenorth-001 --location uaenorth
az storage account create \
  --name sttfstatetestuae001 \
  --resource-group rg-tfstate-test-uaenorth-001 \
  --location uaenorth \
  --sku Standard_LRS \
  --encryption-services blob \
  --https-only true \
  --min-tls-version TLS1_2

az storage container create \
  --name tfstate \
  --account-name sttfstatetestuae001

# Production Environment
az group create --name rg-tfstate-prod-uaenorth-001 --location uaenorth
az storage account create \
  --name sttfstateproduae001 \
  --resource-group rg-tfstate-prod-uaenorth-001 \
  --location uaenorth \
  --sku Standard_GRS \
  --encryption-services blob \
  --https-only true \
  --min-tls-version TLS1_2

az storage container create \
  --name tfstate \
  --account-name sttfstateproduae001

# Enable versioning for production (recommended)
az storage account blob-service-properties update \
  --account-name sttfstateproduae001 \
  --enable-versioning true
```

**Update Backend Configuration Files:**

Update the storage account names in:
- `terraform/environments/dev/backend.tfvars`
- `terraform/environments/test/backend.tfvars`
- `terraform/environments/prod/backend.tfvars`

## 🚀 Pipeline Setup

### Create Pipeline from YAML

1. Navigate to **Pipelines** → **Pipelines**
2. Click **New pipeline**
3. Select **Azure Repos Git**
4. Choose **acr-k8s-dev-micro** repository
5. Select **Existing Azure Pipelines YAML file**
6. **Path**: `/.azuredevops/pipelines/terraform-pipeline.yml`
7. Click **Continue**
8. Review the pipeline YAML
9. Click **Run** (or **Save** if not ready)

### Pipeline Configuration

The pipeline uses the following structure:

```yaml
# Trigger on main and develop branches
trigger:
  branches:
    include:
    - main
    - develop

# Use self-hosted agent pool
pool:
  name: 'WSL-Agent'

# Multi-stage deployment
stages:
  - Plan_Dev → Apply_Dev (auto)
  - Plan_Test → Apply_Test (auto, main branch only)
  - Plan_Prod → Apply_Prod (manual approval, main branch only)
```

### Pipeline Variables

Add pipeline-specific variables:

1. Click on your pipeline → **Edit**
2. Click **Variables** (top-right)
3. Add:
   - `TF_VERSION`: `1.13.0` (or your Terraform version)
   - `TF_IN_AUTOMATION`: `true`

## 🔒 Security Best Practices

### 1. Branch Policies

Protect the `main` branch:

1. Navigate to **Repos** → **Branches**
2. Click `...` on `main` → **Branch policies**
3. Configure:
   - ☑️ **Require a minimum number of reviewers**: 1 (or 2 for production)
   - ☑️ **Check for linked work items**: Recommended
   - ☑️ **Check for comment resolution**: All comments resolved
   - ☑️ **Build validation**: Add your Terraform pipeline

### 2. Service Connection Permissions

1. Go to each service connection
2. Click **Security**
3. Verify:
   - ☑️ **Project Collection Build Service** has **User** role only
   - ☐ **Remove** any unnecessary Administrator permissions

### 3. State File Security

Ensure state files are encrypted and access-controlled:

```bash
# Enable encryption at rest (already done above)
# Enable soft delete and blob versioning
az storage account blob-service-properties update \
  --account-name sttfstateproduae001 \
  --enable-delete-retention true \
  --delete-retention-days 30

# Enable RBAC access only (disable key access)
az storage account update \
  --name sttfstateproduae001 \
  --allow-shared-key-access false
```

### 4. Secret Management

- Store all secrets in Azure Key Vault
- Reference Key Vault secrets in variable groups
- Never commit secrets to repository
- Rotate PATs and service principal secrets every 90 days

## 📊 Pipeline Execution Flow

### Development Deployment

```
Git Push to 'develop' or 'main'
    ↓
[Plan_Dev Stage]
    - Checkout code
    - Install Terraform
    - Terraform init (dev backend)
    - Terraform plan (dev.tfvars)
    - Upload plan artifact
    ↓
[Apply_Dev Stage]
    - Download plan artifact
    - Terraform apply (auto-approve)
    - Publish outputs
```

### Test/Staging Deployment

```
Git Push to 'main' only
    ↓
[Plan_Test Stage]
    - Checkout code
    - Install Terraform
    - Terraform init (test backend)
    - Terraform plan (stg.tfvars)
    - Upload plan artifact
    ↓
[Apply_Test Stage]
    - Download plan artifact
    - Terraform apply (auto-approve)
    - Publish outputs
```

### Production Deployment

```
Git Push to 'main' only
    ↓
[Plan_Prod Stage]
    - Checkout code
    - Install Terraform
    - Terraform init (prod backend)
    - Terraform plan (prd.tfvars)
    - Upload plan artifact
    ↓
[Wait for Manual Approval]
    ↓
[Apply_Prod Stage]
    - Download plan artifact
    - Terraform apply (auto-approve)
    - Publish outputs
    - Tag release
```

## 🧪 Testing the Pipeline

### 1. Test Dev Deployment

```bash
# Make a small change
git checkout -b feature/test-pipeline
echo "# Test" >> terraform/test.md
git add .
git commit -m "test: pipeline validation"
git push origin feature/test-pipeline

# Create PR to develop
# Merge to develop → triggers Plan_Dev + Apply_Dev
```

### 2. Test Full Pipeline

```bash
# Merge develop to main
git checkout main
git merge develop
git push origin main

# This triggers:
# - Dev deployment
# - Test deployment
# - Prod plan (waits for approval)
```

### 3. Monitor Pipeline

1. Navigate to **Pipelines** → **Pipelines**
2. Click on your running pipeline
3. Monitor each stage:
   - ✅ Green: Success
   - 🟡 Yellow: Running/Waiting
   - ❌ Red: Failed
4. Click on stage to view logs

## 🔧 Troubleshooting

### Common Issues

**Issue: "TF401019: The Git repository does not exist"**
- Verify repository name matches exactly
- Check you have permissions to the project

**Issue: "Authentication failed"**
- Regenerate PAT with correct scopes (Agent Pools read+manage)
- Update Git credential helper: `git config --global credential.helper manager`

**Issue: "Agent pool not found"**
- Verify agent pool name is `WSL-Agent` (case-sensitive)
- Check agent is online in Organization Settings

**Issue: "Service connection not found"**
- Verify service connection names match exactly in YAML
- Check pipeline has permission to use the service connection

**Issue: "Backend initialization failed"**
- Verify storage account exists and is accessible
- Check backend.tfvars has correct values
- Ensure service principal has Storage Blob Data Contributor role

**Issue: "No hosted parallelism"**
- Use self-hosted agent (WSL-Agent) instead
- Or request free tier parallelism from Azure DevOps support

### View Pipeline Logs

```bash
# In pipeline run, click on failed stage
# Click on failed task
# View detailed logs
# Download logs for offline analysis
```

### Debug Terraform Issues

Add debug logging to pipeline:

```yaml
- script: |
    export TF_LOG=DEBUG
    terraform plan -var-file="terraform/environments/$(environmentName).tfvars" -out=tfplan
  displayName: 'Terraform Plan (Debug Mode)'
```

## 📚 Additional Resources

- [Azure DevOps Pipeline Documentation](https://docs.microsoft.com/en-us/azure/devops/pipelines/)
- [Terraform Azure Backend](https://www.terraform.io/docs/language/settings/backends/azurerm.html)
- [Azure Verified Modules](https://aka.ms/avm)
- [Self-hosted Agents](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/agents)

## 🆘 Support

For issues or questions:
1. Check pipeline logs for specific error messages
2. Review Terraform plan output
3. Verify all prerequisites are met
4. Contact DevOps team: devops@jlurisenterprise.com

---

**Last Updated**: November 12, 2025  
**Maintained By**: Infrastructure Team

# Push to github and azuredevops

git add .
git commit -m "will use local"
git push

git push origin main && git push azure main
---

# Azure DevOps Built-in Path Variables Reference

## 📁 Common Pipeline Variables and Their Actual Paths

Based on your WSL-Agent environment (Dell-Predator-G15-5530):

### Build Stage Paths:
```yaml
# Source code checkout location
$(Build.SourcesDirectory)
# Actual: /home/azureuser/agent/_work/1/s
# or: C:\agent\_work\1\s (Windows)

# Root working directory for the build
$(System.DefaultWorkingDirectory) 
# Actual: /home/azureuser/agent/_work/1/s
# Same as Build.SourcesDirectory during build

# Artifact staging directory (where you copy files before publishing)
$(Build.ArtifactStagingDirectory)
# Actual: /home/azureuser/agent/_work/1/a
# or: C:\agent\_work\1\a

# Binary output directory
$(Build.BinariesDirectory)
# Actual: /home/azureuser/agent/_work/1/b

# Repository name
$(Build.Repository.Name)
# Actual: acr-k8s-dev-micro

# Pipeline workspace root
$(Pipeline.Workspace)
# Actual: /home/azureuser/agent/_work/1
```

### Deployment/Release Stage Paths:
```yaml
# During deployment jobs (after artifact download)
$(Pipeline.Workspace)
# Actual: /home/azureuser/agent/_work/1

# Downloaded artifacts location
$(Pipeline.Workspace)/terraform-files
# Actual: /home/azureuser/agent/_work/1/terraform-files

$(Pipeline.Workspace)/tfplan
# Actual: /home/azureuser/agent/_work/1/tfplan

# System default working directory (deployment stage)
$(System.DefaultWorkingDirectory)
# Actual: /home/azureuser/agent/_work/1
# Different from Build stage - no /s suffix
```

### Agent Information:
```yaml
# Agent name
$(Agent.Name)
# Actual: Dell-Predator-G15-5530

# Agent machine name
$(Agent.MachineName)
# Actual: Dell-Predator-G15-5530

# Agent home directory
$(Agent.HomeDirectory)
# Actual: /home/azureuser/agent

# Agent tools directory
$(Agent.ToolsDirectory)
# Actual: /home/azureuser/agent/_work/_tool

# Build/Work directory
$(Agent.BuildDirectory)
# Actual: /home/azureuser/agent/_work/1
```

### Build Information:
```yaml
# Build ID (unique number)
$(Build.BuildId)
# Example: 123

# Build number
$(Build.BuildNumber)
# Example: 20251118.1

# Source branch
$(Build.SourceBranch)
# Example: refs/heads/main or refs/heads/feature1

# Source branch name only
$(Build.SourceBranchName)
# Example: main or feature1

# Build reason
$(Build.Reason)
# Values: Manual, IndividualCI, BatchedCI, PullRequest, Schedule
```

### Environment-Specific Variables:
```yaml
# Tenant ID
$(TENANT_ID)
# Actual: 7d1a04ec-981a-405a-951b-dd2733120e4c

# Subscription IDs (per environment)
$(SUBSCRIPTION_ID_nonprod)
# Actual: 43731ed3-ead8-4406-b85d-18e966dfdb9f

$(SUBSCRIPTION_ID_BACKEND)
# Actual: Your backend subscription ID

# Terraform Backend Storage
$(TF_STORAGE_RESOURCE_GROUP)
$(TF_STORAGE_ACCOUNT_NAME)
$(TF_CONTAINER_NAME)
```

### Useful Path Examples in Your Pipeline:

```yaml
# Terraform working directory during plan
$(Build.SourcesDirectory)/terraform
# Actual: /home/azureuser/agent/_work/1/s/terraform

# Environment tfvars file
$(Build.SourcesDirectory)/terraform/environments/nonprod.tfvars
# Actual: /home/azureuser/agent/_work/1/s/terraform/environments/nonprod.tfvars

# Backend config file location
$(Build.SourcesDirectory)/terraform/backend.tfvars
# Actual: /home/azureuser/agent/_work/1/s/terraform/backend.tfvars

# Staging tfplan for publishing
$(Build.ArtifactStagingDirectory)/tfplan/tfplan
# Actual: /home/azureuser/agent/_work/1/a/tfplan/tfplan

# Downloaded tfplan during apply
$(Pipeline.Workspace)/tfplan/tfplan
# Actual: /home/azureuser/agent/_work/1/tfplan/tfplan

# Security scan results
$(System.DefaultWorkingDirectory)/scan-results
# Actual: /home/azureuser/agent/_work/1/s/scan-results
```

## 🔑 Key Differences to Remember

### 1. Build vs Deployment Stage
- **Build Stage**: `$(System.DefaultWorkingDirectory)` = `/agent/_work/1/s`
- **Deploy Stage**: `$(System.DefaultWorkingDirectory)` = `/agent/_work/1`

### 2. Source Code Access
- **Build stage**: Files are in `$(Build.SourcesDirectory)`
- **Deploy stage**: Must download artifacts to `$(Pipeline.Workspace)`

### 3. Artifact Flow
- **Copy to**: `$(Build.ArtifactStagingDirectory)` → Publish artifact
- **Download to**: `$(Pipeline.Workspace)/<artifact-name>`

## 🐛 Debug Command to See All Paths

Add this to any pipeline step to debug path issues:

```yaml
- script: |
    echo "===== Pipeline Path Variables ====="
    echo "Build.SourcesDirectory: $(Build.SourcesDirectory)"
    echo "System.DefaultWorkingDirectory: $(System.DefaultWorkingDirectory)"
    echo "Build.ArtifactStagingDirectory: $(Build.ArtifactStagingDirectory)"
    echo "Pipeline.Workspace: $(Pipeline.Workspace)"
    echo "Agent.BuildDirectory: $(Agent.BuildDirectory)"
    echo "Agent.Name: $(Agent.Name)"
    echo ""
    echo "===== Current Directory ====="
    pwd
    echo ""
    echo "===== Directory Contents ====="
    ls -la
  displayName: "Debug: Display All Paths"
```

