# Pipeline Variables

This directory contains variable template files that are imported into the main pipeline. Variables are organized by scope:

## File Structure

```
variables/
├── common-variables.yml      # Shared across all environments
├── dev-variables.yml          # Development environment
├── stg-variables.yml          # Staging/Test environment
├── prd-variables.yml          # Production environment
├── data-variables.yml         # Data environment
└── int-variables.yml          # Integration environment
```

## Usage

Variables are automatically loaded in the main pipeline based on the selected environment parameter:

```yaml
# In terraform-pipeline.yml
parameters:
- name: environment
  values: [dev, stg, prd, data, int]

variables:
- template: ../templates/variables/common-variables.yml  # Always loaded
- ${{ if eq(parameters.environment, 'dev') }}:
  - template: ../templates/variables/dev-variables.yml   # Loaded only for dev
```

## Setup Instructions

### 1. Get Your Azure Subscription IDs

```bash
# Login to Azure
az login

# List all subscriptions
az account list --output table

# Get specific subscription ID
az account show --subscription "Subscription Name" --query id -o tsv

# Get tenant ID
az account show --query tenantId -o tsv
```

### 2. Update Variable Files

Edit each file and replace placeholder values:

**common-variables.yml:**
- `TENANT_ID` → Your Azure AD tenant ID
- `SUBSCRIPTION_ID_PRD` → Production subscription (for Terraform state backend)
- `TF_STORAGE_RESOURCE_GROUP` → Resource group name for state storage
- `TF_STORAGE_ACCOUNT_NAME` → Storage account name for state
- `TF_CONTAINER_NAME` → Blob container name (usually `tfstate`)

**Environment-specific files (dev/stg/prd/data/int):**
- `SUBSCRIPTION_ID_{env}` → Subscription ID for that environment
- `ENVIRONMENT_NAME` → Environment identifier
- `LOCATION` → Azure region (e.g., `uaenorth`)

### 3. Example Values

**common-variables.yml:**
```yaml
variables:
  - name: TENANT_ID
    value: 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
  
  - name: SUBSCRIPTION_ID_PRD
    value: '11111111-2222-3333-4444-555555555555'
  
  - name: TF_STORAGE_RESOURCE_GROUP
    value: 'rg-tfstate-prd-uaenorth-001'
  
  - name: TF_STORAGE_ACCOUNT_NAME
    value: 'sttfstateprd001'
```

**dev-variables.yml:**
```yaml
variables:
  - name: SUBSCRIPTION_ID_dev
    value: '66666666-7777-8888-9999-000000000000'
```

## Security Considerations

### ✅ What to Store Here
- Subscription IDs (not secret)
- Tenant IDs (not secret)
- Resource names (not secret)
- Azure regions (not secret)
- Environment identifiers (not secret)

### ❌ What NOT to Store Here
- Service principal secrets (use Azure DevOps Library with secret masking)
- Storage account keys (use Azure AD authentication)
- Passwords or tokens (use Azure Key Vault)
- API keys (use Azure Key Vault)

## Best Practices

1. **Use Azure AD Authentication**: Set `use_azuread_auth = true` in backend config
2. **No Secrets in Code**: Never commit secrets to Git
3. **Consistent Naming**: Follow naming convention: `SUBSCRIPTION_ID_{env}`
4. **Document Changes**: Update this README when adding new variables
5. **Version Control**: Track changes to variables through Git history

## Adding New Environments

To add a new environment (e.g., `qa`):

1. Create `qa-variables.yml`:
   ```yaml
   variables:
     - name: SUBSCRIPTION_ID_qa
       value: 'YOUR_QA_SUBSCRIPTION_ID'
     - name: ENVIRONMENT_NAME
       value: 'qa'
     - name: LOCATION
       value: 'uaenorth'
   ```

2. Update `terraform-pipeline.yml`:
   ```yaml
   parameters:
   - name: environment
     values: [dev, stg, prd, data, int, qa]  # Add qa
   
   variables:
   - ${{ if eq(parameters.environment, 'qa') }}:
     - template: ../templates/variables/qa-variables.yml
   ```

3. Create environment-specific tfvars: `terraform/environments/qa.tfvars`

4. Create Azure DevOps Environment: `MR-Approval-qa`

## Troubleshooting

**Issue: Variables not loading**
- Verify file path is correct: `../templates/variables/`
- Check YAML syntax (indentation matters!)
- Ensure environment parameter matches variable file name

**Issue: Subscription ID not found**
- Verify variable name follows pattern: `SUBSCRIPTION_ID_{env}`
- Check the environment parameter value matches the file condition

**Issue: Wrong subscription being used**
- Confirm `SUBSCRIPTION_ID_PRD` is for backend storage
- Confirm `SUBSCRIPTION_ID_{env}` matches target environment

---

**Last Updated**: November 12, 2025  
**Maintained By**: DevOps Team
