output "id" {
  value       = local.enabled ? local.id : ""
  description = "Disambiguated ID"
}

output "name" {
  value       = local.enabled ? local.name : ""
  description = "Normalized name"
}

output "namespace" {
  value       = local.enabled ? local.namespace : ""
  description = "Normalized namespace"
}

output "stage" {
  value       = local.enabled ? local.stage : ""
  description = "Normalized stage"
}

output "environment" {
  value       = local.enabled ? local.environment : ""
  description = "Normalized environment"
}

output "attributes" {
  value       = local.attributes
  description = "List of attributes"
}

output "all_attributes" {
  value       = local.all_attributes
  description = "List of all attributes"
}

output "attributes_is_null" {
  value       = local.attributes == null ? "yes" : "no"
}

output "all_attributes_is_null" {
  value       = local.all_attributes == null ? "yes" : "no"
}

output "delimiter" {
  value       = local.enabled ? local.delimiter : ""
  description = "Delimiter between `namespace`, `environment`, `stage`, `name` and `attributes`"
}

output "tags" {
  value       = local.tags
  description = "Normalized Tag map"
}

output "context" {
  value       = local.output_context
  description = "Context of this module to pass to other label modules"
}

output "label_order" {
  value       = local.label_order
  description = "The naming order of the id output and Name tag"
}

output "input_context" {
  value       = var.context
}

output "input_attributes" {
  value       = var.attributes
}
