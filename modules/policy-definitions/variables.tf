variable "mandatory_tag_keys" {
  type        = "list"
  description = "List of mandatory tag keys used by policies 'addTagToRG','inheritTagFromRG','bulkAddTagsToRG','bulkInheritTagsFromRG'"
  default = [
    "Application",
    "CostCentre",
    "Environment",
    "ManagedBy",
    "OwnedBy",
    "SupportBy"
  ]

}

variable "mandatory_tag_value" {
  type        = "string"
  description = "Tag value to include with the mandatory tag keys used by policies 'addTagToRG','inheritTagFromRG','bulkAddTagsToRG','bulkInheritTagsFromRG'"
  default     = "to_be_confirmed"
}

variable "policy_definition_category" {
  type        = "string"
  description = "The category to use for all Policy Definitions"
  default     = "Custom"
}