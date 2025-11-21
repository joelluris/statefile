# Azure DevOps Project Permissions

## Overview
This document outlines the permissions and capabilities for different roles in Azure DevOps Project Settings.

---

## Built-in Security Groups

### 1. **Readers**
**Purpose:** View-only access to project resources

**Project Settings Permissions:**
- ✅ **View** project-level information
- ✅ **View** project properties and settings
- ✅ **View** work items
- ✅ **View** repositories (read-only)
- ✅ **View** pipelines and builds
- ✅ **View** test plans and results
- ✅ **View** dashboards and analytics
- ❌ **Cannot create** any resources
- ❌ **Cannot modify** any settings
- ❌ **Cannot delete** anything
- ❌ **Cannot manage** permissions

**Use Cases:**
- External stakeholders who need visibility
- Auditors reviewing project status
- Management oversight
- Compliance monitoring

---

### 2. **Contributors**
**Purpose:** Standard development team members with read/write access

**Project Settings Permissions:**
- ✅ **All Reader permissions** (inherited)
- ✅ **Create and edit** work items
- ✅ **Create and manage** branches
- ✅ **Create and complete** pull requests
- ✅ **Run Queue and cancel** builds
- ✅ **Edit** build definitions
- ✅ **Create and edit** releases
- ✅ **Create and manage** test plans
- ✅ **Add and edit** wiki pages
- ✅ **Create** dashboards
- ❌ **Cannot modify** project settings
- ❌ **Cannot manage** security/permissions
- ❌ **Cannot delete** repositories or pipelines
- ❌ **Cannot manage** service connections
- ❌ **Cannot approve** production deployments (requires additional permissions)

**Use Cases:**
- Developers
- QA engineers
- DevOps engineers (day-to-day operations)

---

### 3. **Project Administrators**
**Purpose:** Full control over project configuration and settings

**Project Settings Permissions:**
- ✅ **All Contributor permissions** (inherited)
- ✅ **Modify** project settings and configuration
- ✅ **Create and delete** repositories
- ✅ **Manage** branch policies and permissions
- ✅ **Create and delete** pipelines
- ✅ **Manage** service connections
- ✅ **Configure** environments and approvals
- ✅ **Manage** variable groups and libraries
- ✅ **Add and remove** users from groups
- ✅ **Modify** security permissions
- ✅ **Configure** project-level policies
- ✅ **Manage** project area and iteration paths
- ✅ **Delete** project resources
- ✅ **Configure** notifications and alerts
- ✅ **Manage** extensions and integrations
- ✅ **Export** and archive project data

**Use Cases:**
- Project leads
- DevOps architects
- Team administrators
- Technical managers

---

## Detailed Permission Breakdown

### **Repositories**
| Action                    | Reader | Contributor | Project Admin |
|---------------------------|--------|-------------|---------------|
| View code                 | ✅     | ✅          | ✅            |
| Clone repository          | ✅     | ✅          | ✅            |
| Create branch             | ❌     | ✅          | ✅            |
| Push commits              | ❌     | ✅          | ✅            |
| Create PR                 | ❌     | ✅          | ✅            |
| Complete PR               | ❌     | ✅*         | ✅            |
| Manage branch policies    | ❌     | ❌          | ✅            |
| Delete repository         | ❌     | ❌          | ✅            |

*Requires branch policy approval if configured

#### **Repository-Specific Permissions:**
| Permission                     | Reader | Contributor | Project Admin | Description                        |
|--------------------------------|--------|-------------|---------------|------------------------------------|  
| Read                           | ✅     | ✅          | ✅            | View repository files and history  |
| Contribute                     | ❌     | ✅          | ✅            | Push commits, create branches      |
| Contribute to pull requests    | ❌     | ✅          | ✅            | Create and comment on PRs          |
| Force push                     | ❌     | ❌          | ✅            | Overwrite history (dangerous)      |
| Manage permissions             | ❌     | ❌          | ✅            | Change repository security         |
| Remove others' locks           | ❌     | ❌          | ✅            | Remove branch locks set by others  |
| Rename repository              | ❌     | ❌          | ✅            | Change repository name             |
| Edit policies                  | ❌     | ❌          | ✅            | Configure branch policies          |
| Bypass policies on push        | ❌     | ❌          | ✅**          | Push without policy validation     |
| Bypass policies on completion  | ❌     | ❌          | ✅**          | Merge PR without approvals         |

**Should be restricted even for admins

#### **Branch Policies (Configurable):**
- Require minimum number of reviewers (1-10)
- Check for linked work items
- Check for comment resolution
- Enforce merge strategies (squash, rebase, no-fast-forward)
- Require build validation
- Automatically include code reviewers
- Reset votes on new pushes

### **Pipelines**
| Action                         | Reader | Contributor | Project Admin |
|--------------------------------|--------|-------------|---------------|
| View pipelines                 | ✅     | ✅          | ✅            |
| Run/Queue build                | ❌     | ✅          | ✅            |
| Edit pipeline                  | ❌     | ✅          | ✅            |
| Delete pipeline                | ❌     | ❌          | ✅            |
| Manage service connections     | ❌     | ❌          | ✅            |
| Manage environments            | ❌     | ❌          | ✅            |
| Manage variable groups         | ❌     | ✅          | ✅            |
| Approve production deployment  | ❌     | ❌*         | ✅            |

*Can be granted explicitly via Environment approvers

#### **Pipeline-Specific Permissions:**
| Permission                     | Reader | Contributor | Project Admin | Description                      |
|--------------------------------|--------|-------------|---------------|----------------------------------|
| View builds                    | ✅     | ✅          | ✅            | See build results and logs       |
| View build pipeline            | ✅     | ✅          | ✅            | View pipeline YAML/Classic UI    |
| Run/Queue builds               | ❌     | ✅          | ✅            | Trigger manual pipeline runs     |
| Edit build pipeline            | ❌     | ✅          | ✅            | Modify pipeline configuration    |
| Delete build pipeline          | ❌     | ❌          | ✅            | Permanently remove pipeline      |
| Manage build qualities         | ❌     | ✅          | ✅            | Mark build quality (good/bad)    |
| Override check-in validation   | ❌     | ❌          | ✅            | Bypass CI triggers               |
| Retain indefinitely            | ❌     | ✅          | ✅            | Keep builds from auto-deletion   |
| Stop builds                    | ❌     | ✅          | ✅            | Cancel running builds            |
| View build resources           | ✅     | ✅          | ✅            | View agents and pools            |
| Administer build permissions   | ❌     | ❌          | ✅            | Manage pipeline security         |

#### **Release Pipeline Permissions:**
| Permission                   | Reader | Contributor | Project Admin | Description                    |
|------------------------------|--------|-------------|---------------|--------------------------------|
| View releases                | ✅     | ✅          | ✅            | See release status and history |
| View release pipeline        | ✅     | ✅          | ✅            | View release definition        |
| Create releases              | ❌     | ✅          | ✅            | Trigger new releases           |
| Edit release pipeline        | ❌     | ✅          | ✅            | Modify release stages/tasks    |
| Delete release pipeline      | ❌     | ❌          | ✅            | Remove release definition      |
| Manage deployments           | ❌     | ✅*         | ✅            | Approve/reject deployments     |
| Manage release approvers     | ❌     | ❌          | ✅            | Configure approval gates       |
| Delete releases              | ❌     | ❌          | ✅            | Remove release records         |

*Requires environment approval configuration

#### **Environment Permissions:**
| Permission     | Reader | Contributor | Project Admin | Description              |
|----------------|--------|-------------|---------------|-------------------------|
| View           | ✅     | ✅          | ✅            | See environment details  |
| User           | ❌     | ✅*         | ✅            | Deploy to environment    |
| Creator        | ❌     | ❌          | ✅            | Create new environments  |
| Administrator  | ❌     | ❌          | ✅            | Full environment control |

*Requires explicit permission or approval group membership

### **Service Connections**
| Action                      | Reader | Contributor | Project Admin |
|-----------------------------|--------|-------------|---------------|
| View service connections    | ❌     | ❌          | ✅            |
| Use service connections     | ❌     | ✅*         | ✅            |
| Create service connections  | ❌     | ❌          | ✅            |
| Edit service connections    | ❌     | ❌          | ✅            |
| Delete service connections  | ❌     | ❌          | ✅            |

*Only if explicitly granted or pipeline has permission

#### **Service Connection Permissions:**
| Permission                     | Reader | Contributor | Project Admin | Description                                |
|--------------------------------|--------|-------------|---------------|--------------------------------------------|  
| View service connection        | ❌     | ❌          | ✅            | See connection details (credentials hidden)|
| Use service connection         | ❌     | ✅*         | ✅            | Reference in pipeline                      |
| Administer service connection  | ❌     | ❌          | ✅            | Modify and manage security                 |
| Create service connection      | ❌     | ❌          | ✅            | Add new connections                        |

*Requires explicit permission per service connection

#### **Service Connection Types:**
- **Azure Resource Manager** - Deploy to Azure subscriptions
- **GitHub** - Access GitHub repositories
- **Docker Registry** - Push/pull container images
- **Kubernetes** - Deploy to K8s clusters
- **Generic** - Custom service endpoints
- **SSH** - Secure shell connections
- **Maven** - Java package repositories
- **NuGet** - .NET package feeds

#### **Service Connection Security Best Practices:**
1. ✅ Use Azure AD authentication instead of service principals when possible
2. ✅ Grant pipeline-level permissions, not project-level
3. ✅ Enable "Grant access to all pipelines" only for non-production
4. ✅ Require manual approval for production service connections
5. ✅ Rotate credentials regularly (90 days recommended)
6. ✅ Use Azure Key Vault for storing secrets
7. ✅ Enable audit logging for connection usage

### **Work Items**
| Action                   | Reader | Contributor | Project Admin |
|--------------------------|--------|-------------|---------------|
| View work items          | ✅     | ✅          | ✅            |
| Create work items        | ❌     | ✅          | ✅            |
| Edit work items          | ❌     | ✅          | ✅            |
| Delete work items        | ❌     | ✅          | ✅            |
| Manage area paths        | ❌     | ❌          | ✅            |
| Manage iteration paths   | ❌     | ❌          | ✅            |

### **Project Settings**
| Action                   | Reader | Contributor | Project Admin |
|--------------------------|--------|-------------|---------------|
| View settings            | ✅     | ✅          | ✅            |
| Modify general settings  | ❌     | ❌          | ✅            |
| Manage teams             | ❌     | ❌          | ✅            |
| Manage security          | ❌     | ❌          | ✅            |
| Manage notifications     | ❌     | ❌          | ✅            |
| Configure dashboards     | ❌     | ✅          | ✅            |

---

## Best Practices

### **Security Recommendations:**
1. **Principle of Least Privilege:** Grant minimum necessary permissions
2. **Reader Role:** Default for new users until role is determined
3. **Contributor Role:** Standard for development team members
4. **Project Administrator:** Limit to 2-3 trusted individuals
5. **Service Accounts:** Create dedicated accounts with specific permissions

### **Environment-Specific Approvals:**
- Configure Environment approvers separately from project roles
- Production deployments should require explicit approval
- Use multiple approvers for critical environments

### **Regular Audits:**
- Review project permissions quarterly
- Remove inactive users promptly
- Monitor Project Administrator assignments

---

## Additional Considerations

### **Organization-Level Roles:**
- **Project Collection Administrators:** Can manage all projects in the organization
- **Organization Owner:** Full control over entire Azure DevOps organization

### **Custom Security Groups:**
You can create custom groups with tailored permissions, such as:
- "Release Managers" - Can approve production deployments
- "Security Reviewers" - Can view security scan results
- "Infrastructure Team" - Manage service connections and environments

---

## Quick Reference

**Need to view only?** → **Reader**  
**Need to develop and commit code?** → **Contributor**  
**Need to configure project settings?** → **Project Administrator**

---

*Last Updated: November 21, 2025*  
*Project: enterprise-integrations*
