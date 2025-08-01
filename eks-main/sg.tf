resource "aws_security_group" "security_group" {
  for_each    = var.sg
  name        = "${var.cluster_name}-${each.key}"
  vpc_id      = var.vpc_id
  description = "Security Group for ${var.cluster_name}-${each.key}"
  tags = merge(
    local.common_tags,
    each.value.additional_tags
  )
}

resource "aws_security_group_rule" "sg_rule" {
  for_each                 = { for idx, sg_rule in var.sg_rules : idx => sg_rule }
  security_group_id        = aws_security_group.security_group[each.value.security_group].id
  type                     = each.value.type
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  description              = each.value.description
  self                     = try(each.value.source_self_sg, false) ? each.value.source_self_sg : null
  cidr_blocks              = try(each.value.source_whole_vpc, false) ? [data.aws_vpc.selected.cidr_block] : try(each.value.cidr, null)
  source_security_group_id = try(each.value.source_cluster_sg, false) ? aws_security_group.security_group["master-sg"].id : null
}