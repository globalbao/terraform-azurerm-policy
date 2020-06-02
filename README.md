# AzureRM Policy - Terraform parent module

* Vendor reference [https://www.terraform.io/docs/providers/azurerm/index.html](https://www.terraform.io/docs/providers/azurerm/index.html)

## Example Usage

### Pre-Reqs

* Setup a new Azure [service principal](https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html) to your subscription for terraform to use.
* Assign the ["Resource Policy Contributor"](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#resource-policy-contributor) built-in role for least amount of privileges required.

```azurecli
az login
az account list
az account set --subscription="XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXX"
az ad sp create-for-rbac --name "Terraform-AzureRM-Policy" --role="Resource Policy Contributor" --scopes="/subscriptions/XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXX"
```

* Store your Azure service principal credentials as per below in a .tfvars file e.g. .\workspaces\subscriptionName\subscriptionName.tfvars to call when using terraform plan/apply.

```
tenant_id       = "your tenant id"
subscription_id = "your subscription id"
client_id       = "your service principal appId"
client_secret   = "your service principal password"
```

* If changes are made to .tf files it's best practice to use terraform fmt/validate.

```terraform
terraform fmt -recursive
terraform validate
```

* Create a new workspace in terraform-azurerm-policy\workspaces\subscriptionName.
* Folder path must exist prior to running terraform workspace.

```terraform
terraform workspace new subscriptionName ".\workspaces\subscriptionName"
terraform workspace list
```
### Plan/Apply

* Run parent module within workspace context using Azure service principal credentials in subscriptionName.tfvars
* Assumes current working directory is .\terraform-azurerm-policy.

```terraform
terraform init
terraform workspace select subscriptionName
terraform workspace show
terraform plan -out=".\workspaces\subscriptionName\tfplan" -var-file=".\workspaces\subscriptionName\subscriptionName.tfvars"
terraform apply ".\workspaces\subscriptionName\tfplan"
terraform apply -var-file=".\workspaces\subscriptionName\subscriptionName.tfvars"
```

### Cleanup

* Delete/remove all created terraform resources

```terraform
terraform workspace select subscriptionName
terraform workspace show
terraform destroy -var-file=".\workspaces\subscriptionName\subscriptionName.tfvars"
```

* Delete/cleanup your Azure service principal if not needed.

```azurecli
az login
az account list
az account set --subscription="XXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXX"
az ad sp delete --id "<appId>"
```

## Module files

* `main.tf`
* `outputs.tf`
* `variables.tf`

## Resources (main.tf)

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

## Input variables (variables.tf)

| Name               | Description                           | Type     | Default Value
|:-------------------|:--------------------------------------|:---------|:--------------
| `subscription_id`  | Your Azure Subscription ID            | `string` | null
| `client_id`        | Your Azure Service Principal appId    | `string` | null
| `client_secret`    | Your Azure Service Principal Password | `string` | null
| `tenant_id`        | Your Azure Tenant ID                  | `string` | null

## Output variables (outputs.tf)

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
