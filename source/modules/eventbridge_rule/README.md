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
| [aws_cloudwatch_event_rule.event_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.event_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_batch_target_specs"></a> [batch\_target\_specs](#input\_batch\_target\_specs) | The specifications for the Batch job to submit | <pre>object({<br>    job_definition = string<br>    job_name       = string<br>    array_size     = number<br>    job_attempts   = number<br>  })</pre> | `null` | no |
| <a name="input_event_bus_name"></a> [event\_bus\_name](#input\_event\_bus\_name) | The name of the event bus to associate with this rule. Default to default | `string` | `"default"` | no |
| <a name="input_event_pattern"></a> [event\_pattern](#input\_event\_pattern) | The event pattern that rule should capture. At least one of schedule\_expression or event\_pattern is required. | `string` | `null` | no |
| <a name="input_input_transformer_specs"></a> [input\_transformer\_specs](#input\_input\_transformer\_specs) | The input transformer specifications for the rule | <pre>object({<br>    input_paths    = map(string)<br>    input_template = string<br>  })</pre> | `null` | no |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | If enable the rule. Default to true | `bool` | `true` | no |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | The ARN of the IAM role to be used for this target when the rule is triggered | `string` | `null` | no |
| <a name="input_rule_description"></a> [rule\_description](#input\_rule\_description) | The description of the rule | `string` | `""` | no |
| <a name="input_rule_input"></a> [rule\_input](#input\_rule\_input) | The input of the rule | `string` | `"{}"` | no |
| <a name="input_rule_name"></a> [rule\_name](#input\_rule\_name) | The name of EventBridge rule to trigger a submit of job | `string` | n/a | yes |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression) | The schedule expression for CW Event rule in UTC. Trigger at 1:00 AM at UTC | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The key value pairs we want to apply as tags to the resources contained in this module | `map(string)` | `{}` | no |
| <a name="input_target_arn"></a> [target\_arn](#input\_target\_arn) | The ARN of the target | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_event_rule_arn"></a> [event\_rule\_arn](#output\_event\_rule\_arn) | ARN of the EventBridge rule |
