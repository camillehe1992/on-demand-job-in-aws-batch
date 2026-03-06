## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_batch_execution_role"></a> [batch\_execution\_role](#module\_batch\_execution\_role) | ../../modules/iam_role | n/a |
| <a name="module_batch_instance_role"></a> [batch\_instance\_role](#module\_batch\_instance\_role) | ../../modules/iam_role | n/a |
| <a name="module_eventbridge_role"></a> [eventbridge\_role](#module\_eventbridge\_role) | ../../modules/iam_role | n/a |
| <a name="module_secrets"></a> [secrets](#module\_secrets) | ../../modules/secretsmanager | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy_document.cw_event_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | The name of application. Must be lowercase without special chars | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | The environment of application | `string` | n/a | yes |
| <a name="input_secret_specs"></a> [secret\_specs](#input\_secret\_specs) | A map of secrets with key-value pairs | <pre>map(object({<br/>    description   = string<br/>    secret_string = string<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The key value pairs we want to apply as tags to the resources contained in this module | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_batch_execution_role_arn"></a> [batch\_execution\_role\_arn](#output\_batch\_execution\_role\_arn) | ARN of the Batch execution role |
| <a name="output_batch_instance_role_arn"></a> [batch\_instance\_role\_arn](#output\_batch\_instance\_role\_arn) | ARN of the Batch instance role |
| <a name="output_eventbridge_role_arn"></a> [eventbridge\_role\_arn](#output\_eventbridge\_role\_arn) | ARN of the EventBridge role |
| <a name="output_secrets"></a> [secrets](#output\_secrets) | Secrets of the Batch job |
