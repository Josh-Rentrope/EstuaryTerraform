# iam.tf

# IAM user for Estuary to assume the role
resource "aws_iam_user" "estuary" {
  name = "${var.project_name}-user"
  tags = var.tags
}

resource "aws_iam_access_key" "estuary" {
  user = aws_iam_user.estuary.name
}

# IAM group for Estuary users.
resource "aws_iam_group" "estuary" {
  name = "${var.project_name}-group"
}

# Add the Estuary user to the group.
resource "aws_iam_group_membership" "estuary" {
  name = "${var.project_name}-group-membership"

  users = [
    aws_iam_user.estuary.name,
  ]
  group = aws_iam_group.estuary.name
}

# IAM role that Estuary will assume
resource "aws_iam_role" "estuary" {
  name = "${var.project_name}-role"
  tags = var.tags

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_user.estuary.arn
        }
      }
    ]
  })
}

# --- S3 Permissions ---
# This policy grants read/write access to the specific S3 bucket created for Estuary.
# This follows the principle of least privilege.
data "aws_iam_policy_document" "s3_read_write" {
  statement {
    sid    = "S3ReadWriteAccess"
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetObjectVersion"
    ]
    resources = [
      aws_s3_bucket.data_drop.arn,      # For bucket-level operations (e.g., ListBucket)
      "${aws_s3_bucket.data_drop.arn}/*" # For object-level operations (e.g., GetObject, PutObject)
    ]
  }
}

resource "aws_iam_policy" "s3_read_write" {
  name        = "${var.project_name}-s3-read-write-policy"
  description = "Policy for Estuary to read/write from S3 buckets."
  policy      = data.aws_iam_policy_document.s3_read_write.json
}

resource "aws_iam_role_policy_attachment" "s3_read_write" {
  role       = aws_iam_role.estuary.name
  policy_arn = aws_iam_policy.s3_read_write.arn
}

# Attach the S3 policy to the group as well for clear permission management.
resource "aws_iam_group_policy_attachment" "s3_read_write" {
  group      = aws_iam_group.estuary.name
  policy_arn = aws_iam_policy.s3_read_write.arn
}

# --- (Optional) RDS PostgreSQL Permissions ---
# This policy grants common data access permissions for RDS.
# You can attach this if Estuary needs to connect to a PostgreSQL database on RDS.
data "aws_iam_policy_document" "rds_postgres_access" {
  statement {
    sid    = "RDSPostgresAccess"
    effect = "Allow"
    actions = [
      "rds-data:ExecuteStatement",
      "rds-data:BatchExecuteStatement",
      "rds-data:BeginTransaction",
      "rds-data:CommitTransaction",
      "rds-data:RollbackTransaction"
    ]
    # IMPORTANT: Restrict this to your specific RDS database ARN for security.
    # Example: "arn:aws:rds:us-east-1:123456789012:db:your-db-identifier"
    resources = [
      "arn:aws:rds:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:db:*"
    ]
  }
}

resource "aws_iam_policy" "rds_postgres_access" {
  name        = "${var.project_name}-rds-postgres-access-policy"
  description = "Policy for Estuary to access RDS PostgreSQL."
  policy      = data.aws_iam_policy_document.rds_postgres_access.json
}

# To enable RDS access, uncomment the following block.
# resource "aws_iam_role_policy_attachment" "rds_postgres_access" {
#   role       = aws_iam_role.estuary.name
#   policy_arn = aws_iam_policy.rds_postgres_access.arn
# }

# --- Data sources to get current account and region info ---
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
