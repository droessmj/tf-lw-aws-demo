#!/bin/sh

account="account3"

# manage aws config per scenario
if cat ~/.aws/config | grep "$account"; then
    export AWS_PROFILE="$account"
    echo "AWS_PROFILE = $AWS_PROFILE"

    export AWS_DEFAULT_REGION="us-east-1"
    echo "AWS_DEFAULT_REGION = $AWS_DEFAULT_REGION"
fi

if [ -z "$1" ]; then
    terraform init
    terraform apply --auto-approve
else
    # TODO: add handling to empty/stop versioning bucket prior to delete or delete fails
    terraform destroy --auto-approve
fi