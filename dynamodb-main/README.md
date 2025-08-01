# DynamoDB Terraform Module
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_dynamodb_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attributes"></a> [attributes](#input\_attributes) | List of nested attribute definitions for hash\_key and range\_key attributes. Each attribute should have two properties: name - (Required) The name of the attribute, type - (Required) Attribute type, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data | `list(map(string))` | `[]` | no |
| <a name="input_billing_mode"></a> [billing\_mode](#input\_billing\_mode) | Either PROVISIONED or PAY\_PER\_REQUEST | `string` | `"PAY_PER_REQUEST"` | no |
| <a name="input_deletion_protection_enabled"></a> [deletion\_protection\_enabled](#input\_deletion\_protection\_enabled) | Enables deletion protection for table | `bool` | `false` | no |
| <a name="input_global_secondary_indexes"></a> [global\_secondary\_indexes](#input\_global\_secondary\_indexes) | Global Secondary Indexes | `any` | `[]` | no |
| <a name="input_hash_key"></a> [hash\_key](#input\_hash\_key) | Partition Key Name. Attribute for same has to be set in attributes block - String(S) / Number(N) / Binary(N) | `string` | `null` | no |
| <a name="input_import_table"></a> [import\_table](#input\_import\_table) | Configuration for importing s3 data into table | `any` | `{}` | no |
| <a name="input_local_secondary_indexes"></a> [local\_secondary\_indexes](#input\_local\_secondary\_indexes) | Local Secondary Indexes | `any` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Table Name | `string` | `""` | no |
| <a name="input_point_in_time_recovery_enabled"></a> [point\_in\_time\_recovery\_enabled](#input\_point\_in\_time\_recovery\_enabled) | Enable / Disable Point in time recovery | `bool` | `false` | no |
| <a name="input_range_key"></a> [range\_key](#input\_range\_key) | Sort Key Name. Attribute for same has to be set in attributes block - String(S) / Number(N) / Binary(N) | `string` | `null` | no |
| <a name="input_read_capacity"></a> [read\_capacity](#input\_read\_capacity) | Read Capacity Units, required only if the billing\_mode is PROVISIONED | `number` | `null` | no |
| <a name="input_replica_regions"></a> [replica\_regions](#input\_replica\_regions) | Regions for replica | `any` | `[]` | no |
| <a name="input_server_side_encryption_enabled"></a> [server\_side\_encryption\_enabled](#input\_server\_side\_encryption\_enabled) | Enable / Disable Server Side Encryption | `bool` | `true` | no |
| <a name="input_server_side_encryption_kms_key_arn"></a> [server\_side\_encryption\_kms\_key\_arn](#input\_server\_side\_encryption\_kms\_key\_arn) | Arn of KMS Key for encryption | `string` | `""` | no |
| <a name="input_stream_enabled"></a> [stream\_enabled](#input\_stream\_enabled) | Enable / Disable streams for table | `bool` | `false` | no |
| <a name="input_stream_view_type"></a> [stream\_view\_type](#input\_stream\_view\_type) | Stream view type - valid values are KEYS\_ONLY, NEW\_IMAGE, OLD\_IMAGE, NEW\_AND\_OLD\_IMAGES, required only if stream is enabled | `string` | `null` | no |
| <a name="input_table_class"></a> [table\_class](#input\_table\_class) | Storage class for table - STANDARD / STANDARD\_INFREQUENT\_ACCESS | `string` | `"STANDARD"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Madatory Tags | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Resource Management Timeouts | `map(string)` | <pre>{<br>  "create": "10m",<br>  "delete": "10m",<br>  "update": "60m"<br>}</pre> | no |
| <a name="input_ttl_attribute_name"></a> [ttl\_attribute\_name](#input\_ttl\_attribute\_name) | Table attribute name to store ttl | `string` | `""` | no |
| <a name="input_ttl_enabled"></a> [ttl\_enabled](#input\_ttl\_enabled) | Enable / Disable TTL | `bool` | `false` | no |
| <a name="input_write_capacity"></a> [write\_capacity](#input\_write\_capacity) | Write Capacity Units, required only if the billing\_mode is PROVISIONED | `number` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->