#!/bin/bash

# --- User Configuration ---
# The S3 bucket where Terraform state will be stored.
# IMPORTANT: This bucket must exist before you run the script.
TERRAFORM_STATE_BUCKET="your-terraform-state-bucket-name"

# The path/key for the state file within the S3 bucket.
TERRAFORM_STATE_KEY="estuary/terraform.tfstate"

# The AWS region where the S3 bucket is located.
TERRAFORM_STATE_REGION="us-east-1"
# --- End of User Configuration ---

# Initialize Terraform with the S3 backend configuration.
echo "Initializing Terraform..."
terraform init \
    -backend-config="bucket=${TERRAFORM_STATE_BUCKET}" \
    -backend-config="key=${TERRAFORM_STATE_KEY}" \
    -backend-config="region=${TERRAFORM_STATE_REGION}"

# Apply the Terraform configuration.
echo "Applying Terraform plan..."
terraform apply -auto-approve

echo "Deployment complete. Check the Terraform outputs for your credentials."
