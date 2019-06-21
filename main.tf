locals {

  defaults = {
    label_order = ["namespace", "environment", "stage", "name", "attributes"]
    delimiter   = "-"
    replacement = "",
    empty_state = "~~"
  }

  # Provided values provided by variables superceed values inherited from the context

  enabled             = var.enabled
  regex_replace_chars = coalesce(var.regex_replace_chars, var.context.regex_replace_chars)

  name                = lower(replace(coalesce(var.name, var.context.name, local.defaults.empty_state), local.regex_replace_chars, local.defaults.replacement))
  namespace           = (
    var.namespace != "" || var.context.namespace != ""
      ? lower(replace(coalesce(var.namespace, var.context.namespace, local.defaults.empty_state), local.regex_replace_chars, local.defaults.replacement))
      : ""
  )
  environment         = (
    var.environment != "" || var.context.environment != ""
      ? lower(replace(coalesce(var.environment, var.context.environment, local.defaults.empty_state), local.regex_replace_chars, local.defaults.replacement))
      : ""
  )
  stage               = (
    var.stage != "" || var.context.stage != ""
    ? lower(replace(coalesce(var.stage, var.context.stage, local.defaults.empty_state), local.regex_replace_chars, local.defaults.replacement))
    : ""
  )
  delimiter           = coalesce(var.delimiter, var.context.delimiter, local.defaults.delimiter)
  label_order         = length(var.label_order) > 0 ? var.label_order : (length(var.context.label_order) > 0 ? var.context.label_order : local.defaults.label_order)
  additional_tag_map  = merge(var.context.additional_tag_map, var.additional_tag_map)

  all_attributes      = (
    var.context.attributes != null && length(var.context.attributes) > 0
     ? compact(concat(var.attributes, var.context.attributes))
     : compact(var.attributes)
  )

  # Merge attributes
  attributes = length(local.all_attributes) > 0 ? distinct(local.all_attributes) : []

  # FIXME: need to filter out empty tags
  generated_tags = {
    for l in keys(local.id_context) :
    title(l) => local.id_context[l]
    if length(local.id_context[l]) > 0
  }

  tags                 = merge(var.context.tags, local.generated_tags, var.tags)

  id_context = {
    name        = local.name == local.defaults.empty_state ? "" : local.name
    namespace   = local.namespace == local.defaults.empty_state ? "" : local.namespace
    environment = local.environment == local.defaults.empty_state ? "" : local.environment
    stage       = local.stage == local.defaults.empty_state ? "" : local.stage
    attributes  = (
      length(local.all_attributes) > 0
        ? lower(replace(join(local.delimiter, local.attributes), local.regex_replace_chars, local.defaults.replacement))
        : ""
    )
  }

  labels = [for l in local.label_order : local.id_context[l]]

  id = lower(join(local.delimiter, compact(local.labels)))

  # Context of this label to pass to other label modules
  output_context = {
    enabled             = local.enabled
    name                = local.name
    namespace           = local.namespace
    environment         = local.environment
    stage               = local.stage
    attributes          = length(local.all_attributes) > 0 ? local.attributes : local.all_attributes
    tags                = local.tags
    delimiter           = local.delimiter
    label_order         = local.label_order
    additional_tag_map  = local.additional_tag_map
    regex_replace_chars = local.regex_replace_chars
  }
}
