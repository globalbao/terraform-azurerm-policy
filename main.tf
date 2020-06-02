terraform {
  required_version = "~> 0.12.0"
  required_providers {
    azurerm = "~> 2.11.0"
  }
}

provider "azurerm" {
  # skip provider rego because we are using a service principal with limited access to Azure
  skip_provider_registration = "true"

  # input Azure service principal details for AuthN
  tenant_id       = "${var.tenant_id}"
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"

  features {}
}

# call the Azure Policy Assignments module
# warning---> Policy Enforcement mode is 'Enabled' by default on new assignments. Ensure to change Policy Enforcement mode to 'Disabled' if required.
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
