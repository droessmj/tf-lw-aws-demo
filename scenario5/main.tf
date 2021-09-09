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
  alias  = "log_archive_account"
  profile  = "[profile name for log_archive account in ~/.aws/credentials]"
  region = "YourAWSRegion"
}

provider "aws" {
  alias  = "audit_account"
  profile  = "[profile name for audit account in ~/.aws/credentials]"
  region = "YourAWSRegion"
}

module "cloudtrail-controltower" {
  source = "lacework/cloudtrail-controltower/aws"
  version = "~> 0.1"
  providers = {
    aws.audit = aws.audit_account
    aws.log_archive = aws.log_archive_account
  }
  # The only two required variables are the SNS topic ARN and the S3 Bucket ARN where the CloudTrail logs are stored
  # SNS Topic ARN is usually in the form: arn:aws:sns:[control_tower_region]:[aws_audit_account_id]:aws-controltower-AllConfigNotifications
  sns_topic_arn   = "arn:aws:sns:[control_tower_region]:[aws_audit_account_id]:aws-controltower-AllConfigNotifications"
  # S3 Bucket ARN is usually in the form: arn:aws:s3:::aws-controltower-logs-[log_archive_account_id]-[control_tower_region]
  s3_bucket_arn = "arn:aws:s3:::aws-controltower-logs-[log_archive_account_id]-[control_tower_region]"
}