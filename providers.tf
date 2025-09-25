# providers.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {} # Configuration will be passed via CLI
}

provider "aws" {
  region = var.aws_region
}
