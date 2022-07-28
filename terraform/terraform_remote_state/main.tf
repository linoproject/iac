provider "aws" {
  region = "eu-west-1"
}

variable "region" {
    default = "eu-west-1"
}

variable "company_name" {
    default = "mycorp"
}

variable "environment" {
    default = "dev"
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "terraform_backend" {
    bucket = "${var.company_name}-${data.aws_caller_identity.current.account_id}-${var.environment}-terrafrom-backend"
    acl    = "private"

    tags = {
        Name        = "${var.company_name}-${data.aws_caller_identity.current.account_id}-${var.environment}-terrafrom-backend"
        Environment = "${var.environment}"
    }
}

output "bucket" {
    value = resource.aws_s3_bucket.terraform_backend
}