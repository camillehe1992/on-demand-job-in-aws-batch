#########################################################################
# Terraform Makefile
#########################################################################
-include .env

SHELL := /bin/bash
BASE := $(shell /bin/pwd)
PIP ?= pip
MAKE ?= make

ENVIRONMENT := dev
UNIT := iam
AWS_PROFILE := app-deployer

TF_BACKEND_CONFIG_FILE = terraform/environments/$(ENVIRONMENT)/config.tfbackend
TF_VAR_FILE = terraform/environments/$(ENVIRONMENT)/terraform.tfvars

TF ?= AWS_PROFILE=${AWS_PROFILE} terraform

pre-check:
	${info [*] Pre-Check - AWS Profile ${AWS_PROFILE}}
	aws sts get-caller-identity --profile ${AWS_PROFILE} | jq .

install:
	$(info [*] Enable Git Commit Hook & Install project dependencies)
	pre-commit install
	@$(PIP) install -r requirements.txt

lint:
	$(info [*] Linting terraform and python code)
	@$(TF) fmt -check -diff -recursive ./terraform
	@$(TF) validate

init: pre-check
	@$(TF) init -reconfigure -backend-config=${TF_BACKEND_CONFIG_FILE}

plan: init
	@$(TF) plan -var-file ${TF_VAR_FILE} -out tfplan

destroy: init
	@$(TF) plan -destroy -var-file ${TF_VAR_FILE} -out tfplan

apply:
	@$(TF) apply tfplan

%-apply:
	@$(MAKE) $*
	@$(MAKE) apply
