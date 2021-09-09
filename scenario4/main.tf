terraform {
  required_providers {
    lacework = {
      source = "lacework/lacework"
      version = "~> 0.3"
    }
  }
}

provider "lacework" {}

provider "aws" {
  alias = "main"
  region = var.main_account_region
  profile = var.main_account_profile
}

module "aws_config_main" {
  source  = "lacework/config/aws"
  version = "~> 0.1"

  providers = {
    aws      = aws.main
  }
}

module "main_cloudtrail" {
  source  = "lacework/cloudtrail/aws"
  version = "~> 0.1"

  providers = {
    aws      = aws.main
  }

  consolidated_trail      = true
  use_existing_cloudtrail = true
  bucket_arn              = var.bucket_arn
  bucket_name             = var.bucket_name
}

provider "aws" {
  alias = "sub_account"
  region = var.secondary_account_region
  profile = var.secondary_account_profile
}

module "aws_config_sub_account" {
  source  = "lacework/config/aws"
  version = "~> 0.1"

  providers = {
    aws      = aws.sub_account
  }
}