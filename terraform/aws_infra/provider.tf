provider "aws" {
   region = var.aws_region
}

terraform {
   required_version = "~> 0.12"

   required_providers {
      aws = "~> 3.10"
   }

   # backend "s3" {
   #    bucket = "terraform-example-com"
   #    key = "state/demo/terraform.tfstate"
   #    region = "us-east-1"
   #    dynamodb_table = "terraform-state-lock"
   #    encrypt = true
   # }
}