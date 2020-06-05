# AzureRM Policy - Terraform parent module

* Vendor reference [https://www.terraform.io/docs/providers/azurerm/index.html](https://www.terraform.io/docs/providers/azurerm/index.html)

## Terraform parent module files

* `main.tf`
* `outputs.tf`
* `variables.tf`

## Terraform resources (main.tf)

|Module                  | Resource Type                 | Resource name                  | Deployment Count
|:-----------------------|:------------------------------|:-------------------------------|:-----
| policy_definitions     | azurerm_policy_definition     | `addTagToRG`                   | 5
| policy_definitions     | azurerm_policy_definition     | `inheritTagFromRG`             | 5
| policy_definitions     | azurerm_policy_definition     | `bulkAddTagsToRG`              | 1
| policy_definitions     | azurerm_policy_definition     | `bulkInheritTagsFromRG`        | 1
| policy_definitions     | azurerm_policy_definition     | `auditRoleAssignmentType_user` | 1
| policy_definitions     | azurerm_policy_definition     | `auditLockOnNetworking`        | 1
| policyset_definitions  | azurerm_policy_set_definition | `tag_governance`               | 1
| policyset_definitions  | azurerm_policy_set_definition | `iam_governance`               | 1
| policyset_definitions  | azurerm_policy_set_definition | `security_governance`          | 1
| policyset_definitions  | azurerm_policy_set_definition | `data_protection_governance`   | 1
| policy_assignments     | azurerm_policy_assignment     | `tag_governance`               | 1
| policy_assignments     | azurerm_policy_assignment     | `iam_governance`               | 1
| policy_assignments     | azurerm_policy_assignment     | `security_governance`          | 1
| policy_assignments     | azurerm_policy_assignment     | `data_protection_governance`   | 1

## Terraform input variables (variables.tf)

* Usable if you have setup an Azure service principal for authentication as per example usage instructions below.

| Name               | Description                           | Type     | Default Value
|:-------------------|:--------------------------------------|:---------|:--------------
| `subscription_id`  | Your Azure Subscription ID            | `string` | null
| `client_id`        | Your Azure Service Principal appId    | `string` | null
| `client_secret`    | Your Azure Service Principal Password | `string` | null
| `tenant_id`        | Your Azure Tenant ID                  | `string` | null

## Terraform output variables (outputs.tf)

| Name                                        | Description                                                 | Value
|:--------------------------------------------|:------------------------------------------------------------|:----------
| `addTagToRG_policy_ids`                     | The policy definition ids for addTagToRG policies           | ${module.policy_definitions.addTagToRG_policy_ids}
| `inheritTagFromRG_policy_ids`               | The policy definition ids for inheritTagFromRG policies     | ${module.policy_definitions.inheritTagFromRG_policy_ids}
| `bulkAddTagsToRG_policy_id`                 | The policy definition ids for inheritTagFromRG policies     | ${module.policy_definitions.bulkAddTagsToRG_policy_id}
| `bulkInheritTagsFromRG_policy_id`           | The policy definition id for bulkInheritTagsFromRG          | ${module.policy_definitions.bulkInheritTagsFromRG_policy_id}
| `auditRoleAssignmentType_user_policy_id`    | The policy definition id for auditRoleAssignmentType_user   | ${module.policy_definitions.auditRoleAssignmentType_user_policy_id}
| `auditLockOnNetworking_policy_id`           | The policy definition id for auditLockOnNetworking          | ${module.policy_definitions.auditLockOnNetworking_policy_id}
| `tag_governance_policyset_id`               | The policy set definition id for tag_governance             | ${module.policyset_definitions.tag_governance_policyset_id}
| `iam_governance_policyset_id`               | The policy set definition id for iam_governance             | ${module.policyset_definitions.iam_governance_policyset_id}
| `security_governance_policyset_id`          | The policy set definition id for security_governance        | ${module.policyset_definitions.security_governance_policyset_id}
| `data_protection_governance_policyset_id`   | The policy set definition id for data_protection_governance | ${module.policyset_definitions.data_protection_governance_policyset_id}
| `tag_governance_assignment_id`              | The policy assignment id for tag_governance                 | ${module.policy_assignments.tag_governance_assignment_id}
| `tag_governance_assignment_identity`        | The policy assignment identity for tag_governance           | ${module.policy_assignments.tag_governance_assignment_identity}
| `iam_governance_assignment_id`              | The policy assignment id for iam_governance                 | ${module.policy_assignments.iam_governance_assignment_id}
| `security_governance_assignment_id`         | The policy assignment id for security_governance            | ${module.policy_assignments.security_governance_assignment_id}
| `security_governance_assignment_identity`   | The policy assignment identity for security_governance      | ${module.policy_assignments.security_governance_assignment_identity}
| `data_protection_governance_assignment_id`  | The policy assignment id for data_protection_governance     | ${module.policy_assignments.data_protection_governance_assignment_id}

## Usage Examples

### Modifying this repo

* If changes are made to `.tf` files it's best practice to use terraform fmt/validate.

```terraform
terraform fmt -recursive
terraform validate
```

### Parent module usage to call child modules

```terraform
terraform {
  required_version = "~> 0.12.0"
  required_providers {
    azurerm = "~> 2.11.0"
  }
}

provider "azurerm" {
  features {}
}

# call the Azure Policy Assignments module
# WARNING--> Policy Enforcement mode is 'Enabled' by default on new assignments. Ensure to change Policy Enforcement mode to 'Disabled' if required.
module "policy_assignments" {
  source = "./modules/policy-assignments"

  tag_governance_policyset_id             = "${module.policyset_definitions.tag_governance_policyset_id}"
  iam_governance_policyset_id             = "${module.policyset_definitions.iam_governance_policyset_id}"
  security_governance_policyset_id        = "${module.policyset_definitions.security_governance_policyset_id}"
  data_protection_governance_policyset_id = "${module.policyset_definitions.data_protection_governance_policyset_id}"
}

# call the Azure Policy Definitions module
module "policy_definitions" {
  source = "./modules/policy-definitions"

}

# call the Azure PolicySet Definitions (initiatives) module
module "policyset_definitions" {
  source = "./modules/policyset-definitions"

  addTagToRG_policy_id_0                 = "${module.policy_definitions.addTagToRG_policy_ids[0]}"
  addTagToRG_policy_id_1                 = "${module.policy_definitions.addTagToRG_policy_ids[1]}"
  addTagToRG_policy_id_2                 = "${module.policy_definitions.addTagToRG_policy_ids[2]}"
  addTagToRG_policy_id_3                 = "${module.policy_definitions.addTagToRG_policy_ids[3]}"
  addTagToRG_policy_id_4                 = "${module.policy_definitions.addTagToRG_policy_ids[4]}"
  addTagToRG_policy_id_5                 = "${module.policy_definitions.addTagToRG_policy_ids[5]}"
  inheritTagFromRG_policy_id_0           = "${module.policy_definitions.inheritTagFromRG_policy_ids[0]}"
  inheritTagFromRG_policy_id_1           = "${module.policy_definitions.inheritTagFromRG_policy_ids[1]}"
  inheritTagFromRG_policy_id_2           = "${module.policy_definitions.inheritTagFromRG_policy_ids[2]}"
  inheritTagFromRG_policy_id_3           = "${module.policy_definitions.inheritTagFromRG_policy_ids[3]}"
  inheritTagFromRG_policy_id_4           = "${module.policy_definitions.inheritTagFromRG_policy_ids[4]}"
  inheritTagFromRG_policy_id_5           = "${module.policy_definitions.inheritTagFromRG_policy_ids[5]}"
  bulkAddTagsToRG_policy_id              = "${module.policy_definitions.bulkAddTagsToRG_policy_id}"
  bulkInheritTagsFromRG_policy_id        = "${module.policy_definitions.bulkInheritTagsFromRG_policy_id}"
  auditRoleAssignmentType_user_policy_id = "${module.policy_definitions.auditRoleAssignmentType_user_policy_id}"
  auditLockOnNetworking_policy_id        = "${module.policy_definitions.auditLockOnNetworking_policy_id}"
}
```

### Terraform plan & apply

* Assumes current working directory is .\terraform-azurerm-policy
* This will plan/apply changes to your Azure subscription

```azurecli
az login
az account list
az account set --subscription="XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXX"
```

```terraform
terraform init
terraform plan
terraform apply
```

### Azure authentication with a service principal and least privilege

* You can setup a new Azure [service principal](https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html) to your subscription for Terraform to use.
* Assign the ["Resource Policy Contributor"](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#resource-policy-contributor) built-in role for least amount of privileges required for the resources in this module.

```azurecli
az login
az account list
az account set --subscription="XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXX"
az ad sp create-for-rbac --name "Terraform-AzureRM-Policy" --role="Resource Policy Contributor" --scopes="/subscriptions/XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXX"
```

* Store your Azure service principal credentials as per below in a .tfvars file e.g. `subscriptionName1.tfvars` to call when using terraform plan/apply.
* Update existing main.tf and variables.tf in the parent root module of this repo to remove `#` comments that've been set for tenant_id, subscription_id, client_id, client_secret.

```
tenant_id       = "your tenant id"
subscription_id = "your subscription id"
client_id       = "your service principal appId"
client_secret   = "your service principal password"
```

### Create multiple terraform workspaces

* You can create multiple workspaces if you need to maintain multiple .tfstate files.
* Note: the workspace folder paths must exist prior to running terraform workspace cmds below.

```terraform
terraform workspace new subscriptionName1 ".\workspaces\subscriptionName1"
terraform workspace new subscriptionName2 ".\workspaces\subscriptionName2"
terraform workspace list
```

### Terraform plan & apply using a workspace and .tfvars

* Assumes current working directory is ".\terraform-azurerm-policy" and you are using an Azure service principal for AuthN.

```terraform
terraform init
terraform workspace list
terraform workspace select subscriptionName1
terraform workspace show
terraform plan -var-file=".\workspaces\subscriptionName1\subscriptionName1.tfvars"
terraform apply -var-file=".\workspaces\subscriptionName1\subscriptionName1.tfvars"
```

### Delete all created terraform resources

* Delete/remove all created terraform resources

```azurecli
az login
az account list
az account set --subscription="XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXX"
```

```terraform
terraform init
terraform destroy
```

### Delete all created terraform resources using a workspace and .tfvars

```terraform
terraform init
terraform workspace list
terraform workspace select subscriptionName1
terraform workspace show
terraform destroy -var-file=".\workspaces\subscriptionName1\subscriptionName1.tfvars"
```

### Delete your Azure service principal if not needed

```azurecli
az login
az account list
az account set --subscription="XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXX"
az ad sp delete --id "<appId>"
```