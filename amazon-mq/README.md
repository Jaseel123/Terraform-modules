# Amazon MQ

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_vault"></a> [vault](#provider\_vault) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_mq_broker.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mq_broker) | resource |
| [aws_mq_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/mq_configuration) | resource |
| [random_password.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [vault_generic_secret.this](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/generic_secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Specifies whether any broker modifications are applied immediately | `any` | n/a | yes |
| <a name="input_audit_log_enabled"></a> [audit\_log\_enabled](#input\_audit\_log\_enabled) | Enables audit logging | `bool` | `false` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Whether to automatically upgrade to new minor versions of brokers as Amazon MQ makes releases available. | `bool` | `false` | no |
| <a name="input_broker_name"></a> [broker\_name](#input\_broker\_name) | Name of the broker. | `string` | n/a | yes |
| <a name="input_configuration_data"></a> [configuration\_data](#input\_configuration\_data) | The configuration data | `string` | n/a | yes |
| <a name="input_data_replication_mode"></a> [data\_replication\_mode](#input\_data\_replication\_mode) | Defines whether this broker is a part of a data replication pair | `string` | `""` | no |
| <a name="input_data_replication_primary_broker_arn"></a> [data\_replication\_primary\_broker\_arn](#input\_data\_replication\_primary\_broker\_arn) | The Amazon Resource Name (ARN) of the primary broker that is used to replicate data from in a data replication pair, and is applied to the replica broker | `string` | n/a | yes |
| <a name="input_deployment_mode"></a> [deployment\_mode](#input\_deployment\_mode) | Deployment mode of the broker | `string` | `"SINGLE_INSTANCE"` | no |
| <a name="input_engine_type"></a> [engine\_type](#input\_engine\_type) | Type of broker engine. Valid values are ActiveMQ and RabbitMQ | `string` | n/a | yes |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Version of the broker engine | `string` | n/a | yes |
| <a name="input_general_log_enabled"></a> [general\_log\_enabled](#input\_general\_log\_enabled) | Enables general logging via CloudWatch | `bool` | `false` | no |
| <a name="input_host_instance_type"></a> [host\_instance\_type](#input\_host\_instance\_type) | Broker's instance type | `string` | n/a | yes |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | Amazon Resource Name (ARN) of Key Management Service (KMS) Customer Master Key (CMK) to use for encryption at rest | `string` | n/a | yes |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Specifies the start time of the maintenance window. | <pre>object({<br>    day_of_week = string<br>    time_of_day = string<br>    time_zone   = string<br>  })</pre> | n/a | yes |
| <a name="input_mq_users"></a> [mq\_users](#input\_mq\_users) | Configuration block for broker users | <pre>list(object({<br>    console_access   = bool<br>    groups           = list(string)<br>    replication_user = bool<br>    username         = string<br>  }))</pre> | `[]` | no |
| <a name="input_publicly_accessible"></a> [publicly\_accessible](#input\_publicly\_accessible) | Whether to enable connections from applications outside of the VPC that hosts the broker's subnets | `bool` | `false` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | List of security group IDs assigned to the broker | `list(string)` | `[]` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs in which to launch the broker. A SINGLE\_INSTANCE deployment requires one subnet. An ACTIVE\_STANDBY\_MULTI\_AZ deployment requires multiple subnets | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Madatory Tags | `map(string)` | `{}` | no |
| <a name="input_vault_path"></a> [vault\_path](#input\_vault\_path) | path rto store rds secrets | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->