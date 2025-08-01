locals {
  eventbridge_rules = flatten([
    for index, rule in var.rules :
    merge(rule, {
      "name" = index
      "Name" = var.append_rule_postfix ? "${replace(index, "_", "-")}-rule" : index
    })
  ])

  eventbridge_targets = flatten([
    for index, rule in var.rules : [
      for target in var.targets[index] :
      merge(target, {
        "rule" = index
        "Name" = var.append_rule_postfix ? "${replace(index, "_", "-")}-rule" : index
      })
    ] if length(var.targets) != 0
  ])

  role_name = var.create_role ? coalesce(var.role_name, var.bus_name, "*") : null

}