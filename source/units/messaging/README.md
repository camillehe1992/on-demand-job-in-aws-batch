## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_capture_failed_batch_job_event_rule"></a> [capture\_failed\_batch\_job\_event\_rule](#module\_capture\_failed\_batch\_job\_event\_rule) | ../../modules/eventbridge_rule | n/a |
| <a name="module_job_failed_alert_sns_topic"></a> [job\_failed\_alert\_sns\_topic](#module\_job\_failed\_alert\_sns\_topic) | ../../modules/sns_topic | n/a |
| <a name="module_submit_batch_job_event_rule"></a> [submit\_batch\_job\_event\_rule](#module\_submit\_batch\_job\_event\_rule) | ../../modules/eventbridge_rule | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy_document.sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | The name of application. Must be lowercase without special chars | `string` | n/a | yes |
| <a name="input_batch_job_definition_arn"></a> [batch\_job\_definition\_arn](#input\_batch\_job\_definition\_arn) | The ARN of Batch job definition | `string` | n/a | yes |
| <a name="input_batch_job_queue_arn"></a> [batch\_job\_queue\_arn](#input\_batch\_job\_queue\_arn) | The ARN of Batch job queue | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | The environment of application | `string` | n/a | yes |
| <a name="input_eventbridge_role_arn"></a> [eventbridge\_role\_arn](#input\_eventbridge\_role\_arn) | The ARN of IAM role to be used for this target when the rule is triggered | `string` | n/a | yes |
| <a name="input_failed_job_notification_enabled"></a> [failed\_job\_notification\_enabled](#input\_failed\_job\_notification\_enabled) | Enable job failed notification SNS Topic email subscription | `bool` | `false` | no |
| <a name="input_notification_email_addresses"></a> [notification\_email\_addresses](#input\_notification\_email\_addresses) | The list of email address that subscribes the SNS topic to receive notification | `list(string)` | `[]` | no |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression) | The schedule expression for CW Event rule in UTC. Trigger at 1:00 AM at UTC | `string` | `"cron(0 4 * * ? *)"` | no |
| <a name="input_submit_job_enabled"></a> [submit\_job\_enabled](#input\_submit\_job\_enabled) | Enable submit Batch job event rule | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The key value pairs we want to apply as tags to the resources contained in this module | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_capture_failed_batch_job_event_rule_arn"></a> [capture\_failed\_batch\_job\_event\_rule\_arn](#output\_capture\_failed\_batch\_job\_event\_rule\_arn) | ARN of the EventBridge rule that captures only job-failed events |
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | ARN of the SNS topic that receives job-failed events |
| <a name="output_submit_batch_job_event_rule_arn"></a> [submit\_batch\_job\_event\_rule\_arn](#output\_submit\_batch\_job\_event\_rule\_arn) | ARN of the EventBridge rule that submits a Batch job as scheduled |
