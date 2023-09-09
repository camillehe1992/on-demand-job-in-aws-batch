BASE := $(shell /bin/pwd)
PIP ?= pip
TF ?= terraform

ENVIRONMENT = dev
NICKNAME = helloworld
AWS_REGION=cn-north-1

export AWS_PROFILE=service.app-deployment-dev-ci-bot
export TF_VAR_my_secret=replace_me

target:
	$(info ${HELP_MESSAGE})
	@exit 0

install:
	$(info [*] Enable Git Commit Hook & Install project dependencies)
	pre-commit install
	@$(PIP) install -r requirements.txt

lint:
	$(info [*] Linting terraform and python code)
	@$(TF) fmt -check -diff -recursive ./terraform
	@$(TF) validate
	@pylint --recursive=y ./app

apply:
	$(info [*] Apply Terrafrom Infra)
	sh ./scripts/apply.sh $(ENVIRONMENT) $(NICKNAME) $(AWS_REGION)

destroy:
	$(info [*] Apply Terrafrom Infra)
	sh ./scripts/apply.sh $(ENVIRONMENT) $(NICKNAME) $(AWS_REGION) destroy