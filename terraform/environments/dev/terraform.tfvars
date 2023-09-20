##############################################
# GENERAL INFORMATION
##############################################

aws_region = "cn-north-1"

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
subnet_ids                 = ["subnet-04839c488f31e2829", "subnet-08122d3fc6e3ce9b1"]
security_group_ids         = ["sg-00fe42c9972b4e4af"]
attempt_duration_seconds   = 60
retry_strategy_attempts    = 3
command                    = ["echo", "hello world"]
job_image_name             = "public.ecr.aws/amazonlinux/amazonlinux:latest"
resource_requirements_vcpu = "1"
resource_requirements_mem  = "128"
log_level                  = "debug"

# CW Event vars
schedule_expression          = "cron(0 4 * * ? *)" # trigger at 4:00 at UTC. 
notification_email_addresses = ["camille.he@outlook.com"]
