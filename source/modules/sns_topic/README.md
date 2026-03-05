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
| [aws_sns_topic.notification_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.allow_publish_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.trigger_topic_emails](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_notification_email_addresses"></a> [notification\_email\_addresses](#input\_notification\_email\_addresses) | The list of email address that subscribes the SNS topic to receive notification | `list(string)` | n/a | yes |
| <a name="input_sns_topic_policy"></a> [sns\_topic\_policy](#input\_sns\_topic\_policy) | The SNS topic policy for allowing particular actions on topic | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | The key value pairs we want to apply as tags to the resources contained in this module | `map(string)` | n/a | yes |
| <a name="input_topic_name"></a> [topic\_name](#input\_topic\_name) | The name of the topic | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | ARN of the SNS topic |
