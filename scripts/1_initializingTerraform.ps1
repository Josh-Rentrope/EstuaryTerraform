# --- User Configuration ---
# The S3 bucket where Terraform state will be stored.
# IMPORTANT: This bucket must exist before you run the script.
$TerraformStateBucket = "your-terraform-state-bucket-name"

# The path/key for the state file within the S3 bucket.
$TerraformStateKey = "estuary/terraform.tfstate"

# The AWS region where the S3 bucket is located.
$TerraformStateRegion = "us-east-1"
# --- End of User Configuration ---

# Initialize Terraform with the S3 backend configuration.
Write-Host "Initializing Terraform..."
terraform init `
    -backend-config="bucket=$TerraformStateBucket" `
    -backend-config="key=$TerraformStateKey" `
    -backend-config="region=$TerraformStateRegion"

# Apply the Terraform configuration.
Write-Host "Applying Terraform plan..."
terraform apply -auto-approve

Write-Host "Deployment complete. Check the Terraform outputs for your credentials."
