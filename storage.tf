 # storage.tf
 
 # S3 bucket for dropping files for Estuary processing.
 # The bucket name includes the AWS account ID to ensure global uniqueness.
 resource "aws_s3_bucket" "data_drop" {
   bucket = "${var.project_name}-data-drop-${data.aws_caller_identity.current.account_id}"
   tags   = var.tags
 }
 
 # Enable versioning to keep a history of objects, which is a best practice.
 resource "aws_s3_bucket_versioning" "data_drop" {
   bucket = aws_s3_bucket.data_drop.id
   versioning_configuration {
     status = "Enabled"
   }
 }
 
 # Enforce server-side encryption by default for all new objects.
 resource "aws_s3_bucket_server_side_encryption_configuration" "data_drop" {
   bucket = aws_s3_bucket.data_drop.id
 
   rule {
     apply_server_side_encryption_by_default {
       sse_algorithm = "AES256"
     }
   }
 }
 
 # Block all public access to the bucket as a security best practice.
 resource "aws_s3_bucket_public_access_block" "data_drop" {
   bucket = aws_s3_bucket.data_drop.id
 
   block_public_acls       = true
   block_public_policy     = true
   ignore_public_acls      = true
   restrict_public_buckets = true
 }