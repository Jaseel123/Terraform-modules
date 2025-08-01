locals {
  for_each_users = var.mq_users != [] ? { for user in var.mq_users : user.username => user } : {}
}
