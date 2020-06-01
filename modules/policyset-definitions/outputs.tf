output "tag_governance_policyset_id" {
  value       = "${azurerm_policy_set_definition.tag_governance.id}"
  description = "The policy set definition id for tag_governance"
}

output "iam_governance_policyset_id" {
  value       = "${azurerm_policy_set_definition.iam_governance.id}"
  description = "The policy set definition id for iam_governance"
}

output "security_governance_policyset_id" {
  value       = "${azurerm_policy_set_definition.security_governance.id}"
  description = "The policy set definition id for security_governance"
}

output "data_protection_governance_policyset_id" {
  value       = "${azurerm_policy_set_definition.data_protection_governance.id}"
  description = "The policy set definition id for data_protection_governance"
}
