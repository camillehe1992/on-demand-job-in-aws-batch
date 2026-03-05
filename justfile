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
    if [ -f .env ]; then
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
    cd ${TG_ENV_DIR} && AWS_PROFILE=${PROFILE} terragrunt run-all plan

# Run-all apply for entire environment
apply-all ENVIRONMENT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_ENV_DIR=$(just tg-env-dir {{ENVIRONMENT}})
    
    echo "[*] Terragrunt run-all apply for {{ENVIRONMENT}}"
    cd ${TG_ENV_DIR} && AWS_PROFILE=${PROFILE} terragrunt run-all apply

# Run-all destroy for entire environment
destroy-all ENVIRONMENT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_ENV_DIR=$(just tg-env-dir {{ENVIRONMENT}})
    
    echo "[*] Terragrunt run-all destroy for {{ENVIRONMENT}}"
    cd ${TG_ENV_DIR} && AWS_PROFILE=${PROFILE} terragrunt run-all destroy

# Run-all output for entire environment
output-all ENVIRONMENT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_ENV_DIR=$(just tg-env-dir {{ENVIRONMENT}})
    
    echo "[*] Terragrunt run-all output for {{ENVIRONMENT}}"
    cd ${TG_ENV_DIR} && AWS_PROFILE=${PROFILE} terragrunt run-all output

# Run-all validate for entire environment
validate-all ENVIRONMENT:
    #!/usr/bin/env bash
    PROFILE=$(just aws-profile)
    TG_ENV_DIR=$(just tg-env-dir {{ENVIRONMENT}})
    
    echo "[*] Terragrunt run-all validate for {{ENVIRONMENT}}"
    cd ${TG_ENV_DIR} && AWS_PROFILE=${PROFILE} terragrunt run-all validate

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
    # find {{PROJECT_ROOT}} -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
    # find {{PROJECT_ROOT}} -type f -name "*.tfstate*" -delete

# Validate justfile syntax
check:
    just --fmt --check

# Format justfile
fmt-just:
    just --fmt

# Show help
help:
    @just --list --unsorted

# Show available units in an environment
list-units ENVIRONMENT:
    #!/usr/bin/env bash
    echo "[*] Available units in {{ENVIRONMENT}}:"
    ls -1 {{PROJECT_ROOT}}/terragrunt/environments/{{ENVIRONMENT}}/ | grep -v "account.hcl" | grep -v "terragrunt.hcl" || true

# Show all environments
list-envs:
    #!/usr/bin/env bash
    echo "[*] Available environments:"
    ls -1 {{PROJECT_ROOT}}/terragrunt/environments/

# Show current settings
show-settings:
    #!/usr/bin/env bash
    echo "ENVIRONMENT: {{ENVIRONMENT}}"
    echo "UNIT: {{UNIT}}"
    echo "PROJECT_ROOT: {{PROJECT_ROOT}}"
    echo "AWS_PROFILE: $(just aws-profile)"
