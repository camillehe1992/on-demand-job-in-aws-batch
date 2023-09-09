##############################################
# GENERAL INFORMATION
##############################################

aws_region  = "cn-north-1"
aws_profile = "service.hyc-deploy-ci-bot"

env      = "dev"
nickname = "helloworld"

tags = {
  environment      = "dev"
  nickname         = "helloworld"
  emails           = "group@example.com"
  application_name = "Hellow World on AWS Batch"
}

##############################################
# BATCH INFORMATION
##############################################
instance_type              = ["c4.large"]
max_vcpus                  = 8
min_vcpus                  = 0
desired_vcpus              = 0
subnet_ids                 = ["subnet-087077f0f70c0fead", "subnet-068a96b742aecee34"]
security_group_ids         = ["sg-03350f19c0194d309"]
attempt_duration_seconds   = 60
retry_strategy_attempts    = 3
command                    = ["echo", "hello world"]
job_image_name             = "public.ecr.aws/amazonlinux/amazonlinux:latest"
resource_requirements_vcpu = "1"
resource_requirements_mem  = "128"
log_level                  = "debug"

# CW Event vars
schedule_expression = "cron(0 4 * * ? *)" # trigger at 4:00 at UTC. 
