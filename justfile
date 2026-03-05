# justfile - Task runner for Terragrunt workflows
# Usage: just [ENVIRONMENT] [UNIT] task
# Example: just plan dev security

# Default values (can be overridden)
ENVIRONMENT := "dev"
UNIT := "security"

# Project root directory (where the justfile is located)
PROJECT_ROOT := `pwd`

# Shell to use
set shell := ["bash", "-uc"]

#export TF_PLUGIN_CACHE_DIR := "~/.terraform.d/plugin-cache"

# ------------------------------------------------------------------------------
# Helper functions (as recipes)
# ------------------------------------------------------------------------------

# Get AWS profile from .env or fallback to "app-deployer"
aws-profile:
    #!/usr/bin/env bash
    # Check if running in GitHub Actions with OIDC
    if [ -n "$GITHUB_ACTIONS" ] && [ -n "$ACTIONS_ID_TOKEN_REQUEST_TOKEN" ]; then
        echo "github-actions-oidc"
    # Fall back to local profile
    elif [ -f .env ]; then
        source .env && echo "${AWS_PROFILE:-app-deployer}"
    else
        echo "app-deployer"
    fi

# ------------------------------------------------------------------------------
# Path helpers (as recipes)
# ------------------------------------------------------------------------------

# Terragrunt unit directory
tg-unit-dir ENVIRONMENT UNIT:
    #!/usr/bin/env bash
    echo "{{PROJECT_ROOT}}/environments/{{ENVIRONMENT}}/{{UNIT}}/"

# Terragrunt environment directory
tg-env-dir ENVIRONMENT:
    #!/usr/bin/env bash
    echo "{{PROJECT_ROOT}}/environments/{{ENVIRONMENT}}/"

# ------------------------------------------------------------------------------
# Core commands
# ------------------------------------------------------------------------------

# Pre-check - Verify AWS credentials
pre-check ENVIRONMENT UNIT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    echo "[*] Pre-Check - AWS Profile ${PROFILE}"
    AWS_PROFILE=${PROFILE} aws sts get-caller-identity | jq .

# Enable Git hooks and install dependencies
install:
    echo "[*] Enable Git Commit Hook & Install project dependencies"
    pre-commit install
    pip install -r requirements.txt

# Terragrunt plan
plan ENVIRONMENT UNIT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_DIR=$(just tg-unit-dir {{ENVIRONMENT}} {{UNIT}})
    
    # First run pre-check
    just pre-check {{ENVIRONMENT}} {{UNIT}}
    
    echo "[*] Terragrunt planning {{ENVIRONMENT}}/{{UNIT}}"
    cd ${TG_DIR} && AWS_PROFILE=${PROFILE} terragrunt plan

# Terragrunt apply
apply ENVIRONMENT UNIT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_DIR=$(just tg-unit-dir {{ENVIRONMENT}} {{UNIT}})
    
    echo "[*] Terragrunt applying {{ENVIRONMENT}}/{{UNIT}}"
    cd ${TG_DIR} && AWS_PROFILE=${PROFILE} terragrunt apply --auto-approve

# Terragrunt destroy
destroy ENVIRONMENT UNIT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_DIR=$(just tg-unit-dir {{ENVIRONMENT}} {{UNIT}})
    
    echo "[*] Terragrunt destroying {{ENVIRONMENT}}/{{UNIT}}"
    cd ${TG_DIR} && AWS_PROFILE=${PROFILE} terragrunt destroy --auto-approve

# Terragrunt output
output ENVIRONMENT UNIT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_DIR=$(just tg-unit-dir {{ENVIRONMENT}} {{UNIT}})
    
    echo "[*] Terragrunt output for {{ENVIRONMENT}}/{{UNIT}}"
    cd ${TG_DIR} && AWS_PROFILE=${PROFILE} terragrunt output

# Terragrunt plan-destroy (plan for destruction)
plan-destroy ENVIRONMENT UNIT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_DIR=$(just tg-unit-dir {{ENVIRONMENT}} {{UNIT}})
    
    # First run pre-check
    just pre-check {{ENVIRONMENT}} {{UNIT}}
    
    echo "[*] Terragrunt planning destruction for {{ENVIRONMENT}}/{{UNIT}}"
    cd ${TG_DIR} && AWS_PROFILE=${PROFILE} terragrunt plan -destroy

# Terragrunt validate
validate ENVIRONMENT UNIT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_DIR=$(just tg-unit-dir {{ENVIRONMENT}} {{UNIT}})
    
    echo "[*] Terragrunt validating {{ENVIRONMENT}}/{{UNIT}}"
    cd ${TG_DIR} && AWS_PROFILE=${PROFILE} terragrunt validate

# Terragrunt fmt (format)
fmt ENVIRONMENT UNIT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_DIR=$(just tg-unit-dir {{ENVIRONMENT}} {{UNIT}})
    
    echo "[*] Terragrunt formatting {{ENVIRONMENT}}/{{UNIT}}"
    cd ${TG_DIR} && AWS_PROFILE=${PROFILE} terragrunt hclfmt

# ------------------------------------------------------------------------------
# Run-all commands (for multiple units)
# ------------------------------------------------------------------------------

# Run-all plan for entire environment
plan-all ENVIRONMENT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_ENV_DIR=$(just tg-env-dir {{ENVIRONMENT}})
    
    echo "[*] Terragrunt run-all plan for {{ENVIRONMENT}}"
    cd ${TG_ENV_DIR} && AWS_PROFILE=${PROFILE} terragrunt run --all plan

# Run-all apply for entire environment
apply-all ENVIRONMENT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_ENV_DIR=$(just tg-env-dir {{ENVIRONMENT}})
    
    echo "[*] Terragrunt run-all apply for {{ENVIRONMENT}}"
    cd ${TG_ENV_DIR} && AWS_PROFILE=${PROFILE} terragrunt run --all apply --non-interactive

# Run-all destroy for entire environment
destroy-all ENVIRONMENT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_ENV_DIR=$(just tg-env-dir {{ENVIRONMENT}})
    
    echo "[*] Terragrunt run-all destroy for {{ENVIRONMENT}}"
    cd ${TG_ENV_DIR} && AWS_PROFILE=${PROFILE} terragrunt run --all destroy 
    
# Run-all output for entire environment
output-all ENVIRONMENT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_ENV_DIR=$(just tg-env-dir {{ENVIRONMENT}})
    
    echo "[*] Terragrunt run-all output for {{ENVIRONMENT}}"
    cd ${TG_ENV_DIR} && AWS_PROFILE=${PROFILE} terragrunt run --all output

# Run-all validate for entire environment
validate-all ENVIRONMENT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_ENV_DIR=$(just tg-env-dir {{ENVIRONMENT}})
    
    echo "[*] Terragrunt run-all validate for {{ENVIRONMENT}}"
    cd ${TG_ENV_DIR} && AWS_PROFILE=${PROFILE} terragrunt run --all validate

# ------------------------------------------------------------------------------
# Utility commands
# ------------------------------------------------------------------------------

# List all available commands
list:
    @just --list

# Clean up temporary files
clean:
    echo "[*] Cleaning up temporary files"
    find {{PROJECT_ROOT}} -type d -name ".terragrunt-cache" -exec rm -rf {} + 2>/dev/null || true
    find {{PROJECT_ROOT}} -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
    find {{PROJECT_ROOT}} -type f -name "*.tfstate*" -delete

# Show help
help:
    @just --list --unsorted

# Show current settings
show-settings:
    #!/usr/bin/env bash
    echo "ENVIRONMENT: {{ENVIRONMENT}}"
    echo "UNIT: {{UNIT}}"
    echo "PROJECT_ROOT: {{PROJECT_ROOT}}"
    echo "AWS_PROFILE: $(just aws-profile)"

# Submit a batch job manually with job-name from terragrunt output
submit-job ENVIRONMENT UNIT JOB_NAME:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_DIR=$(just tg-unit-dir {{ENVIRONMENT}} {{UNIT}})
    
    echo "[*] Fetching job definition and job queue from terragrunt output"
    cd ${TG_DIR}
    
    # Get job definition ARN from terragrunt output
    JOB_DEFINITION=$(AWS_PROFILE=${PROFILE} terragrunt output -raw batch_job_definition_arn 2>/dev/null || echo "")
    if [ -z "$JOB_DEFINITION" ]; then
        echo "[!] Failed to get job definition ARN from terragrunt output"
        echo "[*] Available outputs:"
        AWS_PROFILE=${PROFILE} terragrunt output
        exit 1
    fi
    
    # Get job queue ARN from terragrunt output
    JOB_QUEUE=$(AWS_PROFILE=${PROFILE} terragrunt output -raw batch_job_queue_arn 2>/dev/null || echo "")
    if [ -z "$JOB_QUEUE" ]; then
        echo "[!] Failed to get job queue ARN from terragrunt output"
        echo "[*] Available outputs:"
        AWS_PROFILE=${PROFILE} terragrunt output
        exit 1
    fi
    
    echo "[*] Submitting batch job with:"
    echo "    Environment: {{ENVIRONMENT}}"
    echo "    Unit: {{UNIT}}"
    echo "    Job Name: {{JOB_NAME}}"
    echo "    Job Definition: $JOB_DEFINITION"
    echo "    Job Queue: $JOB_QUEUE"
    
    # Submit the batch job
    echo "[*] Executing: aws batch submit-job --job-name {{JOB_NAME}} --job-definition $JOB_DEFINITION --job-queue $JOB_QUEUE"
    AWS_PROFILE=${PROFILE} aws batch submit-job \
        --job-name "{{JOB_NAME}}" \
        --job-definition "$JOB_DEFINITION" \
        --job-queue "$JOB_QUEUE"
    
    echo "[*] Batch job submitted successfully!"

# ------------------------------------------------------------------------------
# Documentation generation commands
# ------------------------------------------------------------------------------

# Generate documentation for all modules and units under source directory
docs:
    #!/usr/bin/env bash
    echo "[*] Generating documentation for modules and units under source directory"
    
    # Check if terraform-docs is installed
    if ! command -v terraform-docs &> /dev/null; then
        echo "[!] terraform-docs is not installed. Installing..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install terraform-docs
        else
            echo "[!] Please install terraform-docs manually: https://terraform-docs.io/user-guide/installation/"
            exit 1
        fi
    fi
    
    # Generate docs for modules in source/modules/
    echo "[*] Generating documentation for modules in source/modules/"
    for module_dir in {{PROJECT_ROOT}}/source/modules/*/; do
        if [ -d "$module_dir" ]; then
            module_name=$(basename "$module_dir")
            echo "  - Processing module: $module_name"
            terraform-docs markdown "$module_dir" > "$module_dir/README.md" || echo "  [!] Failed to generate docs for $module_name"
        fi
    done
    
    # Generate docs for units in source/units/
    echo "[*] Generating documentation for units in source/units/"
    for unit_dir in {{PROJECT_ROOT}}/source/units/*/; do
        if [ -d "$unit_dir" ]; then
            unit_name=$(basename "$unit_dir")
            echo "  - Processing unit: $unit_name"
            terraform-docs markdown "$unit_dir" > "$unit_dir/README.md" || echo "  [!] Failed to generate docs for $unit_name"
        fi
    done
    
    echo "[*] Documentation generation completed!"

# Clean up all generated documentation
clean-docs:
    #!/usr/bin/env bash
    echo "[*] Cleaning up generated documentation"
    find {{PROJECT_ROOT}}/source/modules -name "README.md" -delete
    find {{PROJECT_ROOT}}/source/units -name "README.md" -delete
    echo "[*] Documentation cleaned up!"

