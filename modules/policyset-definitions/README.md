# AzureRM PolicySet Definitions - Terraform child module
* Vendor reference [https://www.terraform.io/docs/providers/azurerm/r/policy_set_definition.html](https://www.terraform.io/docs/providers/azurerm/r/policy_set_definition.html)

## Module files
* main.tf
* outputs.tf
* variables.tf

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


## Output variables (outputs.tf)

| Name | Description | Value
|:-------|:-----------|:----------
| `tag_governance_policyset_id` | The policy set definition id for tag_governance | ${azurerm_policy_set_definition.tag_governance.id}
| `iam_governance_policyset_id` | The policy set definition id for iam_governance | ${azurerm_policy_set_definition.iam_governance.id}
| `security_governance_policyset_id` | The policy set definition id for security_governance | ${azurerm_policy_set_definition.security_governance.id}
| `data_protection_governance_policyset_id` | The policy set definition id for data_protection_governance | ${azurerm_policy_set_definition.data_protection_governance.id}

