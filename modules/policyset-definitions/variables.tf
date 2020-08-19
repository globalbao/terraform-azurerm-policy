variable "policyset_definition_category" {
  type        = string
  description = "The category to use for all PolicySet defintions"
  default     = "Custom"
}

variable "addTagToRG_policy_id_0" {
  type        = string
  description = "The policy definition id '0' from the 'addTagToRG_policy_ids' output"
}

variable "addTagToRG_policy_id_1" {
  type        = string
  description = "The policy definition id '1' from the 'addTagToRG_policy_ids' output"
}

variable "addTagToRG_policy_id_2" {
  type        = string
  description = "The policy definition id '2' from the 'addTagToRG_policy_ids' output"
}

variable "addTagToRG_policy_id_3" {
  type        = string
  description = "The policy definition id '3' from the 'addTagToRG_policy_ids' output"
}

variable "addTagToRG_policy_id_4" {
  type        = string
  description = "The policy definition id '4' from the 'addTagToRG_policy_ids' output"
}

variable "addTagToRG_policy_id_5" {
  type        = string
  description = "The policy definition id '5' from the 'addTagToRG_policy_ids' output"
}

variable "inheritTagFromRG_policy_id_0" {
  type        = string
  description = "The policy definition id '0' from the 'inheritTagFromRG_policy_ids' output"
}

variable "inheritTagFromRG_policy_id_1" {
  type        = string
  description = "The policy definition id '1' from the 'inheritTagFromRG_policy_ids' output"
}

variable "inheritTagFromRG_policy_id_2" {
  type        = string
  description = "The policy definition id '2' from the 'inheritTagFromRG_policy_ids' output"
}

variable "inheritTagFromRG_policy_id_3" {
  type        = string
  description = "The policy definition id '3' from the 'inheritTagFromRG_policy_ids' output"
}

variable "inheritTagFromRG_policy_id_4" {
  type        = string
  description = "The policy definition id '4' from the 'inheritTagFromRG_policy_ids' output"
}

variable "inheritTagFromRG_policy_id_5" {
  type        = string
  description = "The policy definition id '5' from the 'inheritTagFromRG_policy_ids' output"
}

variable "bulkInheritTagsFromRG_policy_id" {
  type        = string
  description = "The policy definition id for bulkInheritTagsFromRG"
}

variable "auditRoleAssignmentType_user_policy_id" {
  type        = string
  description = "The policy definition id for auditRoleAssignmentType_user"
}

variable "auditLockOnNetworking_policy_id" {
  type        = string
  description = "The policy definition id for auditLockOnNetworking"
}

data "azurerm_policy_definition" "iam_policyset_definitions" {
  count        = length(var.iam_policyset_definitions)
  display_name = var.iam_policyset_definitions[count.index]
}

data "azurerm_policy_definition" "security_policyset_definitions" {
  count        = length(var.security_policyset_definitions)
  display_name = var.security_policyset_definitions[count.index]
}

data "azurerm_policy_definition" "data_protection_policyset_definitions" {
  count        = length(var.data_protection_policyset_definitions)
  display_name = var.data_protection_policyset_definitions[count.index]
}

variable "iam_policyset_definitions" {
  type        = list
  description = "List of policy definitions (display names) for the iam_governance policyset"
  default = [
    "Audit usage of custom RBAC rules",
    "Custom subscription owner roles should not exist",
    "Deprecated accounts should be removed from your subscription",
    "Deprecated accounts with owner permissions should be removed from your subscription",
    "External accounts with write permissions should be removed from your subscription",
    "External accounts with read permissions should be removed from your subscription",
    "External accounts with owner permissions should be removed from your subscription",
    "MFA should be enabled accounts with write permissions on your subscription",
    "MFA should be enabled on accounts with owner permissions on your subscription",
    "MFA should be enabled on accounts with read permissions on your subscription",
    "There should be more than one owner assigned to your subscription"
  ]
}

variable "security_policyset_definitions" {
  type        = list
  description = "List of policy definitions (display names) for the security_governance policyset"
  default = [
    "Internet-facing virtual machines should be protected with network security groups",
    "Subnets should be associated with a Network Security Group",
    "Gateway subnets should not be configured with a network security group",
    "Storage accounts should restrict network access",
    "Secure transfer to storage accounts should be enabled",
    "Access through Internet facing endpoint should be restricted",
    "Storage accounts should allow access from trusted Microsoft services",
    "RDP access from the Internet should be blocked",
    "SSH access from the Internet should be blocked",
    "Disk encryption should be applied on virtual machines",
    "Automation account variables should be encrypted",
    "Azure subscriptions should have a log profile for Activity Log",
    "Email notification to subscription owner for high severity alerts should be enabled",
    "A security contact email address should be provided for your subscription",
    "Enable Azure Security Center on your subscription"
  ]
}

variable "data_protection_policyset_definitions" {
  type        = list
  description = "List of policy definitions (display names) for the data_protection_governance policyset"
  default = [
    "Azure Backup should be enabled for Virtual Machines",
    "Long-term geo-redundant backup should be enabled for Azure SQL Databases",
    "Audit virtual machines without disaster recovery configured",
    "Key Vault objects should be recoverable"
  ]
}
