#!/bin/sh

# manage aws config per scenario
if cat ~/.aws/config | grep account1; then
    export AWS_PROFILE=account1
fi

if [ -z "$1"]; then
    terraform init
    terraform apply --auto-approve
else
    terraform destory --auto-approve
fi