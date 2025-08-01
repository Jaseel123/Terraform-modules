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
| [aws_efs_file_system.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.efs_mount_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_efs_performance_mode"></a> [efs\_performance\_mode](#input\_efs\_performance\_mode) | Performance mode for EFS | `string` | `"generalPurpose"` | no |
| <a name="input_efs_throughput_mode"></a> [efs\_throughput\_mode](#input\_efs\_throughput\_mode) | Throughput mode for EFS | `string` | `"bursting"` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | n/a | `string` | n/a | yes |
| <a name="input_lifecycle_policy"></a> [lifecycle\_policy](#input\_lifecycle\_policy) | Lifecycle policy for EFS | `any` | n/a | yes |
| <a name="input_mount_target"></a> [mount\_target](#input\_mount\_target) | Configuration for EFS mount targets | <pre>object({<br>    subnet_ids      = list(string)<br>    security_groups = list(string)<br>  })</pre> | <pre>{<br>  "security_groups": [],<br>  "subnet_ids": []<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_provisioned_throughput_in_mibps"></a> [provisioned\_throughput\_in\_mibps](#input\_provisioned\_throughput\_in\_mibps) | Throughput in Mibps | `number` | `100` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Default tags | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->