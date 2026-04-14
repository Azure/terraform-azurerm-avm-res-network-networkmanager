locals {
  merged_rules = merge([
    for rc_key, rc in coalesce(var.rule_collections, {}) : {
      for rule_key, rule in rc.rules : "${rc_key}-${rule_key}" => {
        rule_collection_key = rc_key
        rule                = rule
      }
    }
  ]...)
}
