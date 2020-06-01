output "addTagToRG_policy_ids" {
  value       = "${azurerm_policy_definition.addTagToRG.*.id}"
  description = "The policy definition ids for addTagToRG policies"
}

output "inheritTagFromRG_policy_ids" {
  value       = "${azurerm_policy_definition.inheritTagFromRG.*.id}"
  description = "The policy definition ids for inheritTagFromRG policies"
}

output "bulkAddTagsToRG_policy_id" {
  value       = "${azurerm_policy_definition.bulkAddTagsToRG.id}"
  description = "The policy definition id for bulkAddTagsToRG"
}

output "bulkInheritTagsFromRG_policy_id" {
  value       = "${azurerm_policy_definition.bulkInheritTagsFromRG.id}"
  description = "The policy definition id for bulkInheritTagsFromRG"
}

output "auditRoleAssignmentType_user_policy_id" {
  value       = "${azurerm_policy_definition.auditRoleAssignmentType_user.id}"
  description = "The policy definition id for auditRoleAssignmentType_user"
}

output "auditLockOnNetworking_policy_id" {
  value       = "${azurerm_policy_definition.auditLockOnNetworking.id}"
  description = "The policy definition id for auditLockOnNetworking"
}