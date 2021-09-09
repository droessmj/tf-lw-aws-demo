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

  consolidated_trail    = true
  use_existing_iam_role = true
  iam_role_name         = module.aws_config_main.iam_role_name
  iam_role_arn          = module.aws_config_main.iam_role_arn
  iam_role_external_id  = module.aws_config_main.external_id
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

resource "aws_cloudtrail" "lw_sub_account_cloudtrail" {
  provider              = aws.sub_account
  name                  = "lacework-sub-trail"
  is_multi_region_trail = true
  s3_bucket_name        = module.main_cloudtrail.bucket_name
  sns_topic_name        = module.main_cloudtrail.sns_arn
}