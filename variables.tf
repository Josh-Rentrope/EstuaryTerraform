# variables.tf

variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "A name for the project to prefix resources (e.g., 'estuary')."
  type        = string
  default     = "estuary"
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default = {
    ManagedBy   = "Terraform"
    Project     = "Estuary"
    Description = "IAM resources for Estuary integration"
  }
}
