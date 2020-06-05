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

variable "bulkAddTagsToRG_policy_id" {
  type        = string
  description = "The policy definition id for bulkAddTagsToRG"
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

