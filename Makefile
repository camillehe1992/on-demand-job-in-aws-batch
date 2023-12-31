#########################################################################
# Terraform Makefile
#########################################################################
-include .env

SHELL := /bin/bash
BASE := $(shell /bin/pwd)
PIP ?= pip
TF ?= terraform
MAKE ?= make

ENVIRONMENT = dev
NICKNAME = helloworld
AWS_REGION = cn-north-1

AWS_PROFILE := service.app-deployment-${ENVIRONMENT}-ci-bot

install:
	$(info [*] Enable Git Commit Hook & Install project dependencies)
	pre-commit install
	@$(PIP) install -r requirements.txt

lint:
	$(info [*] Linting terraform and python code)
	@$(TF) fmt -check -diff -recursive ./terraform
	@$(TF) validate

init:
	$(info [*] Init Terrafrom Infra)
	@$(TF) init -reconfigure \
		-backend-config=terraform/environments/$(ENVIRONMENT)/config.tfbackend \
		-backend-config="key=$(NICKNAME)/$(ENVIRONMENT)/$(AWS_REGION)/terraform.tfstate"

plan: init
	$(info [*] Plan Terrafrom Infra)
	@$(TF) plan -var-file terraform/environments/$(ENVIRONMENT)/terraform.tfvars \
		-var="aws_profile=${AWS_PROFILE}" \
		-var="my_secret=${MY_SECRET}" \
		-out tfplan

plan-destroy: init
	$(info [*] Plan Terrafrom Infra - Destroy)
	@$(TF) plan -destroy -var-file terraform/environments/$(ENVIRONMENT)/terraform.tfvars -out tfplan

apply: plan
	$(info [*] Apply Terrafrom Infra)
	@$(TF) apply tfplan

apply-destroy: plan-destroy
	$(info [*] Apply Terrafrom Infra - Destroy)
	@$(TF) apply tfplan