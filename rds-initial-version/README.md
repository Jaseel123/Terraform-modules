# rds


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
| [aws_db_instance.rds_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_option_group.rds_option_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_option_group) | resource |
| [aws_db_parameter_group.rds_parameter_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group) | resource |
| [aws_db_subnet_group.rds_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [random_password.rds_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [vault_generic_secret.database_password](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/generic_secret) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Allow major version upgrade | `string` | `"false"` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | immediately apply the changes | `any` | n/a | yes |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Allow automated minor version upgrade (e.g. from Postgres 8.5.3 to Postgres 8.5.4) | `string` | `"true"` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | The window to perform backups in | `string` | `"03:00-04:00"` | no |
| <a name="input_config_groups"></a> [config\_groups](#input\_config\_groups) | Whether to create subnet, parameter, and option groups | `bool` | `true` | no |
| <a name="input_copy_tags_to_snapshot"></a> [copy\_tags\_to\_snapshot](#input\_copy\_tags\_to\_snapshot) | Copy tags from DB to a snapshot | `string` | `"true"` | no |
| <a name="input_create_read_replica"></a> [create\_read\_replica](#input\_create\_read\_replica) | Whether to create a read replica or not | `bool` | `false` | no |
| <a name="input_db_option_group_tags"></a> [db\_option\_group\_tags](#input\_db\_option\_group\_tags) | Additional tags for the DB option group | `map(string)` | `{}` | no |
| <a name="input_db_parameter_group_name"></a> [db\_parameter\_group\_name](#input\_db\_parameter\_group\_name) | Name of the DB parameter group | `any` | n/a | yes |
| <a name="input_db_parameter_group_tags"></a> [db\_parameter\_group\_tags](#input\_db\_parameter\_group\_tags) | Additional tags for the  DB parameter group | `map(string)` | `{}` | no |
| <a name="input_db_subnet_group_tags"></a> [db\_subnet\_group\_tags](#input\_db\_subnet\_group\_tags) | Additional tags for the DB subnet group | `map(string)` | `{}` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | If the DB instance should have deletion protection enabled | `string` | `true` | no |
| <a name="input_encryption_at_rest"></a> [encryption\_at\_rest](#input\_encryption\_at\_rest) | Whether encryption at rest should be enabled | `bool` | `true` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | engine of the RDS | `string` | `"mysql"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Version of the database engine | `string` | `"8.0.35"` | no |
| <a name="input_final_snapshot_identifier"></a> [final\_snapshot\_identifier](#input\_final\_snapshot\_identifier) | The name of your final DB snapshot when this DB instance is deleted | `string` | `null` | no |
| <a name="input_identifier"></a> [identifier](#input\_identifier) | Name of the RDS identifier | `any` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type for the RDS instance | `any` | n/a | yes |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | KMS key ID for encryption | `any` | n/a | yes |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi' UTC | `string` | `"Sun:03:00-Sun:04:00"` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | param to check if the DB to be in Multi AZ or not | `bool` | `"false"` | no |
| <a name="input_option_group_engine"></a> [option\_group\_engine](#input\_option\_group\_engine) | Option group engine type, mysql,mariadb,oracle-se,sqlserver-se etc | `string` | `"mysql"` | no |
| <a name="input_option_group_engine_version"></a> [option\_group\_engine\_version](#input\_option\_group\_engine\_version) | Option group engine type, mysql,mariadb,oracle-se,sqlserver-se etc | `string` | `"8.0"` | no |
| <a name="input_option_group_name"></a> [option\_group\_name](#input\_option\_group\_name) | Name of the DB parameter group | `any` | n/a | yes |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | Name of the DB parameter group | `any` | n/a | yes |
| <a name="input_parametr_group_family"></a> [parametr\_group\_family](#input\_parametr\_group\_family) | family type of the parameter group | `string` | `"mysql8.0"` | no |
| <a name="input_rds_name"></a> [rds\_name](#input\_rds\_name) | Name of the RDS instnace | `any` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs to attach to the RDS instance | `list(string)` | n/a | yes |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Flag to enable final snapshot | `bool` | `true` | no |
| <a name="input_storage_size"></a> [storage\_size](#input\_storage\_size) | storage size of the RDS | `number` | `100` | no |
| <a name="input_subnet_group_name"></a> [subnet\_group\_name](#input\_subnet\_group\_name) | Name of the DB subnet group | `any` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnet IDs for subnet group | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the RDS instance | `map(string)` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | username for admin user | `string` | `"admin"` | no |
| <a name="input_vault_path"></a> [vault\_path](#input\_vault\_path) | path rto store rds secrets | `any` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID of the VPC | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rds_instance_endpoint"></a> [rds\_instance\_endpoint](#output\_rds\_instance\_endpoint) | n/a |
| <a name="output_rds_password"></a> [rds\_password](#output\_rds\_password) | n/a |
<!-- END_TF_DOCS -->