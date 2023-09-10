#!/bin/sh

DIR=$(pwd)
set +e

ENVIRONMENT=$1
NICKNAME=$2
AWS_REGION=$3

if [[ $4 = "destroy" ]]; then
    echo "This is a DESTROY action..."
    PLAN="-destroy"
else
    echo "This is a DEPLOY action..."
    PLAN=""
fi

BACKEND_CONFIG="$DIR/config.tfbackend"
TF_VAR_FILE="$DIR/terraform/environments/$ENVIRONMENT/terraform.tfvars"

terraform init -reconfigure \
    -backend-config=$BACKEND_CONFIG \
    -backend-config="key=$NICKNAME/$ENVIRONMENT/$AWS_REGION/terraform.tfstate"

terraform plan $PLAN -var-file $TF_VAR_FILE -out tfplan

terraform apply tfplan

exit 0
