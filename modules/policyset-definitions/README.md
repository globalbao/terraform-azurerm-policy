# AzureRM PolicySet Definitions - Terraform child module

* Vendor reference [https://www.terraform.io/docs/providers/azurerm/r/policy_set_definition.html](https://www.terraform.io/docs/providers/azurerm/r/policy_set_definition.html)

## Module files

* `main.tf`
* `outputs.tf`
* `variables.tf`

## Resources (main.tf)

| Resource Type | Resource name | Deployment Count
|:--------------|:--------------|:----------------
| azurerm_policy_set_definition | `tag_governance` | 1
| azurerm_policy_set_definition | `iam_governance` | 1
| azurerm_policy_set_definition | `security_governance` | 1
| azurerm_policy_set_definition | `data_protection_governance` | 1

## Input variables (variables.tf)

| Name | Description | Type | Default Value
|:------|:-------------|:------|:---------
| `policyset_definition_category` | The category to use for all PolicySet definitions | `string` | "Custom"
| `addTagToRG_policy_id_0` | The policy definition id '0' from the 'addTagToRG_policy_ids' output | `string` | null
| `addTagToRG_policy_id_1` | The policy definition id '1' from the 'addTagToRG_policy_ids' output | `string` | null
| `addTagToRG_policy_id_2` | The policy definition id '2' from the 'addTagToRG_policy_ids' output | `string` | null
| `addTagToRG_policy_id_3` | The policy definition id '3' from the 'addTagToRG_policy_ids' output | `string` | null
| `addTagToRG_policy_id_4` | The policy definition id '4' from the 'addTagToRG_policy_ids' output | `string` | null
| `addTagToRG_policy_id_5` | The policy definition id '5' from the 'addTagToRG_policy_ids' output | `string` | null
| `inheritTagFromRG_policy_id_0` | The policy definition id '0' from the 'inheritTagFromRG_policy_ids' output | `string` | null
| `inheritTagFromRG_policy_id_1` | The policy definition id '1' from the 'inheritTagFromRG_policy_ids' output | `string` | null
| `inheritTagFromRG_policy_id_2` | The policy definition id '2' from the 'inheritTagFromRG_policy_ids' output | `string` | null
| `inheritTagFromRG_policy_id_3` | The policy definition id '3' from the 'inheritTagFromRG_policy_ids' output | `string` | null
| `inheritTagFromRG_policy_id_4` | The policy definition id '4' from the 'inheritTagFromRG_policy_ids' output | `string` | null
| `inheritTagFromRG_policy_id_5` | The policy definition id '5' from the 'inheritTagFromRG_policy_ids' output | `string` | null
| `bulkAddTagsToRG_policy_id` | The policy definition id for bulkAddTagsToRG | `string` | null
| `bulkInheritTagsFromRG_policy_id` | The policy definition id for bulkInheritTagsFromRG | `string` | null
| `auditRoleAssignmentType_user_policy_id` | The policy definition id for auditRoleAssignmentType_user | `string` | null
| `auditLockOnNetworking_policy_id` | The policy definition id for auditLockOnNetworking | `string` | null
| `iam_policyset_definitions` | List of policy definitions (display names) for the iam_governance policyset | `list` |"Audit usage of custom RBAC rules","Custom subscription owner roles should not exist","Deprecated accounts should be removed from your subscription","Deprecated accounts with owner permissions should be removed from your subscription","External accounts with write permissions should be removed from your subscription","External accounts with read permissions should be removed from your subscription","External accounts with owner permissions should be removed from your subscription","MFA should be enabled accounts with write permissions on your subscription","MFA should be enabled on accounts with owner permissions on your subscription","MFA should be enabled on accounts with read permissions on your subscription","There should be more than one owner assigned to your subscription"
| `security_policyset_definitions` | List of policy definitions (display names) for the security_governance policyset | `list` | "Internet-facing virtual machines should be protected with Network Security Groups","Subnets should be associated with a Network Security Group","Gateway subnets should not be configured with a network security group","Storage accounts should restrict network access","Secure transfer to storage accounts should be enabled","Access through Internet facing endpoint should be restricted","Storage accounts should allow access from trusted Microsoft services","RDP access from the Internet should be blocked","SSH access from the Internet should be blocked","Disk encryption should be applied on virtual machines","Automation account variables should be encrypted","Azure subscriptions should have a log profile for Activity Log","Email notification to subscription owner for high severity alerts should be enabled","A security contact email address should be provided for your subscription","Enable Azure Security Center on your subscription"
| `data_protection_policyset_definitions` | List of policy definitions (display names) for the data_protection_governance policyset | `list` | "Azure Backup should be enabled for Virtual Machines","Long-term geo-redundant backup should be enabled for Azure SQL Databases","Audit virtual machines without disaster recovery configured","Key Vault objects should be recoverable"

## Output variables (outputs.tf)

| Name | Description | Value
|:-------|:-----------|:----------
| `tag_governance_policyset_id` | The policy set definition id for tag_governance | ${azurerm_policy_set_definition.tag_governance.id}
| `iam_governance_policyset_id` | The policy set definition id for iam_governance | ${azurerm_policy_set_definition.iam_governance.id}
| `security_governance_policyset_id` | The policy set definition id for security_governance | ${azurerm_policy_set_definition.security_governance.id}
| `data_protection_governance_policyset_id` | The policy set definition id for data_protection_governance | ${azurerm_policy_set_definition.data_protection_governance.id}
