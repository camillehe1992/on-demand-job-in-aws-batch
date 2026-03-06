## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_batch_compute_environment.compute_environment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/batch_compute_environment) | resource |
| [aws_batch_job_definition.batch_job_definition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/batch_job_definition) | resource |
| [aws_batch_job_queue.batch_job_queue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/batch_job_queue) | resource |
| [random_string.resource_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | The name of application. Must be lowercase without special chars | `string` | n/a | yes |
| <a name="input_attempt_duration_seconds"></a> [attempt\_duration\_seconds](#input\_attempt\_duration\_seconds) | The time duration in seconds after which AWS Batch terminates your jobs if they have not finished. The minimum value for the timeout is 60 seconds. | `number` | n/a | yes |
| <a name="input_batch_instance_role_arn"></a> [batch\_instance\_role\_arn](#input\_batch\_instance\_role\_arn) | The ARN of the IAM role that the container can assume for AWS permissions. | `string` | n/a | yes |
| <a name="input_command"></a> [command](#input\_command) | The command that's passed to the container. | `list(string)` | n/a | yes |
| <a name="input_desired_vcpus"></a> [desired\_vcpus](#input\_desired\_vcpus) | The number of vCPUs that your compute environment launches with. | `number` | `0` | no |
| <a name="input_env"></a> [env](#input\_env) | The environment of application | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment variables to pass to a container. | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | `[]` | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | A list of instance type that launched in batch compute environment | `set(string)` | n/a | yes |
| <a name="input_job_execution_role_arn"></a> [job\_execution\_role\_arn](#input\_job\_execution\_role\_arn) | The ARN of the Batch job execution role that AWS Batch can assume. | `string` | n/a | yes |
| <a name="input_job_image"></a> [job\_image](#input\_job\_image) | The repository name of job image | `string` | `"public.ecr.aws/amazonlinux/amazonlinux:latest"` | no |
| <a name="input_job_role_arn"></a> [job\_role\_arn](#input\_job\_role\_arn) | The ARN of the IAM role that the container can assume for AWS permissions. | `string` | n/a | yes |
| <a name="input_max_vcpus"></a> [max\_vcpus](#input\_max\_vcpus) | The max vCPU that the compute environment maintains | `number` | `16` | no |
| <a name="input_min_vcpus"></a> [min\_vcpus](#input\_min\_vcpus) | The min vCPU that the compute environment maintains | `number` | `0` | no |
| <a name="input_mount_points"></a> [mount\_points](#input\_mount\_points) | The mount points for data volumes in your container. | `list(object({}))` | `[]` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | The parameters that defined in command | `map(string)` | n/a | yes |
| <a name="input_resource_requirements_mem"></a> [resource\_requirements\_mem](#input\_resource\_requirements\_mem) | The memory hard limit (in MiB) present to the container. | `string` | `"128"` | no |
| <a name="input_resource_requirements_vcpu"></a> [resource\_requirements\_vcpu](#input\_resource\_requirements\_vcpu) | The number of vCPUs reserved for the container. Each vCPU is equivalent to 1,024 CPU shares | `string` | `"1"` | no |
| <a name="input_retry_strategy_attempts"></a> [retry\_strategy\_attempts](#input\_retry\_strategy\_attempts) | The number of times to move a job to the RUNNABLE status. You may specify between 1 and 10 attempts. | `number` | n/a | yes |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | The secrets for the container. | <pre>list(object({<br/>    name      = string<br/>    valueFrom = string<br/>  }))</pre> | `[]` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | Security Group ids that Batch job runs in | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet ids that Batch job runs in | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | The key value pairs we want to apply as tags to the resources contained in this module | `map(string)` | `{}` | no |
| <a name="input_volumes"></a> [volumes](#input\_volumes) | A list of data volumes used in a job. | `list(object({}))` | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID that the compute environment is in. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_batch_job_definition_arn"></a> [batch\_job\_definition\_arn](#output\_batch\_job\_definition\_arn) | ARN of the Batch job definition |
| <a name="output_batch_job_queue_arn"></a> [batch\_job\_queue\_arn](#output\_batch\_job\_queue\_arn) | ARN of the Batch job queue |
| <a name="output_compute_environment_arn"></a> [compute\_environment\_arn](#output\_compute\_environment\_arn) | ARN of the Batch compute environment |
