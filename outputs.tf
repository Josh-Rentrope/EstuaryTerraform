# outputs.tf

output "estuary_iam_role_arn" {
  description = "The ARN of the IAM role for Estuary to assume. Plug this into your Estuary connector."
  value       = aws_iam_role.estuary.arn
}

output "estuary_iam_user_access_key_id" {
  description = "The Access Key ID for the IAM user. Estuary will use this to assume the role."
  value       = aws_iam_access_key.estuary.id
  sensitive   = true
}

output "estuary_iam_user_secret_access_key" {
  description = "The Secret Access Key for the IAM user. Estuary will use this to assume the role."
  value       = aws_iam_access_key.estuary.secret
  sensitive   = true
}
 
 output "s3_data_drop_bucket_name" {
   description = "The name of the S3 bucket created for dropping files."
   value       = aws_s3_bucket.data_drop.bucket
 }
