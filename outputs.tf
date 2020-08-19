output "addTagToRG_policy_ids" {
  value       = "${module.policy_definitions.addTagToRG_policy_ids}"
  description = "The policy definition ids for addTagToRG policies"
}

output "inheritTagFromRG_policy_ids" {
  value       = "${module.policy_definitions.inheritTagFromRG_policy_ids}"
  description = "The policy definition ids for inheritTagFromRG policies"
}

output "bulkInheritTagsFromRG_policy_id" {
  value       = "${module.policy_definitions.bulkInheritTagsFromRG_policy_id}"
  description = "The policy definition id for bulkInheritTagsFromRG"
}

output "auditRoleAssignmentType_user_policy_id" {
  value       = "${module.policy_definitions.auditRoleAssignmentType_user_policy_id}"
  description = "The policy definition id for auditRoleAssignmentType_user"
}

output "auditLockOnNetworking_policy_id" {
  value       = "${module.policy_definitions.auditLockOnNetworking_policy_id}"
  description = "The policy definition id for auditLockOnNetworking"
}

output "tag_governance_policyset_id" {
  value       = "${module.policyset_definitions.tag_governance_policyset_id}"
  description = "The policy set definition id for tag_governance"
}

output "iam_governance_policyset_id" {
  value       = "${module.policyset_definitions.iam_governance_policyset_id}"
  description = "The policy set definition id for iam_governance"
}

output "security_governance_policyset_id" {
  value       = "${module.policyset_definitions.security_governance_policyset_id}"
  description = "The policy set definition id for security_governance"
}

output "data_protection_governance_policyset_id" {
  value       = "${module.policyset_definitions.data_protection_governance_policyset_id}"
  description = "The policy set definition id for data_protection_governance"
}

output "tag_governance_assignment_id" {
  value       = "${module.policy_assignments.tag_governance_assignment_id}"
  description = "The policy assignment id for tag_governance"
}

output "tag_governance_assignment_identity" {
  value       = "${module.policy_assignments.tag_governance_assignment_identity}"
  description = "The policy assignment identity for tag_governance"
}

output "iam_governance_assignment_id" {
  value       = "${module.policy_assignments.iam_governance_assignment_id}"
  description = "The policy assignment id for iam_governance"
}

output "security_governance_assignment_id" {
  value       = "${module.policy_assignments.security_governance_assignment_id}"
  description = "The policy assignment id for security_governance"
}

output "security_governance_assignment_identity" {
  value       = "${module.policy_assignments.security_governance_assignment_identity}"
  description = "The policy assignment identity for security_governance"
}

output "data_protection_governance_assignment_id" {
  value       = "${module.policy_assignments.data_protection_governance_assignment_id}"
  description = "The policy assignment id for data_protection_governance"
}

