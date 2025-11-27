# Statefile - Terraform State Validation Project

Enterprise-grade Terraform infrastructure for Azure with state file validation and multi-environment support.

## 📁 Project Structure

```
statefile-validate/
├── .azuredevops/
│   ├── pipelines/
│   │   └── terraform-pipeline.yml
│   └── templates/
│       ├── terraform-init.yml
│       ├── terraform-plan.yml
│       └── terraform-apply.yml
├── terraform/
│   ├── modules/
│   │   ├── acr/              # Azure Container Registry
│   │   ├── aks/              # Azure Kubernetes Service
│   │   ├── network/          # Virtual Networks
│   │   ├── storage/          # Storage Accounts
│   │   └── ... (other modules)
│   ├── environments/
│   │   └── int.tfvars        # Integration environment
│   ├── main.tf
│   ├── variables.tf
│   ├── providers.tf
│   └── outputs.tf
├── .gitignore
└── README.MD
```

## 🚀 Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Azure subscription with appropriate permissions

### Local Development

```bash
# Login to Azure
az login

# Initialize Terraform
cd terraform
terraform init -backend-config=backend.tfvars

# Plan changes
terraform plan -var-file="environments/int.tfvars"

# Apply infrastructure
terraform apply -var-file="environments/int.tfvars"
```

## 🔄 CI/CD Pipeline

This project uses Azure DevOps pipelines for automated deployments across environments.

### Pipeline Stages
1. **Validation** - Terraform format and validate
2. **Plan** - Generate execution plan
3. **Apply** - Deploy infrastructure (with approvals)

## 🔐 Security

- State files are stored in Azure Storage with encryption
- Sensitive variables are managed through Azure Key Vault
- Backend configuration files are excluded from version control

## 📚 Resources

- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Verified Modules](https://aka.ms/avm)

## 👥 Author

Joel Luris
