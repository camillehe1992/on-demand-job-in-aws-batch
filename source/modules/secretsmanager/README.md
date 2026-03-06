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
| [aws_secretsmanager_secret.secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.versions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The KMS key id or ARN to use for encrypting the secret value. If not specified, the default AWS managed key will be used. | `string` | `null` | no |
| <a name="input_recovery_window_in_days"></a> [recovery\_window\_in\_days](#input\_recovery\_window\_in\_days) | The number of days to wait before recovery of the secret. Default is 7 days. | `number` | `7` | no |
| <a name="input_secret_prefix"></a> [secret\_prefix](#input\_secret\_prefix) | The prefix of secret | `string` | `""` | no |
| <a name="input_secret_specs"></a> [secret\_specs](#input\_secret\_specs) | A map of secret specs. Each key is the secret name, and each value is an object with description and secret\_string. | <pre>map(object({<br/>    description   = string<br/>    secret_string = string<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The key value pairs we want to apply as tags to the resources contained in this module | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_secrets"></a> [secrets](#output\_secrets) | n/a |
