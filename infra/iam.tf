# Service account 
resource "aws_iam_user" "etl" {
  name = var.etl_service_account_name
}

# Role assumed by the service account 
resource "aws_iam_role" "etl" {
  name = "etl"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_user.etl.arn
        }
      }
    ]
  })
}


# Policy to access the buckets
resource "aws_iam_policy" "s3_bucket_full" {

  name = "s3_bucket_full"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject",
          "s3:GetBucketLocation"
        ]
        Resource = flatten([
          for bucket_name in var.etl_bucket_names : [
            "arn:${data.aws_partition.current.partition}:s3:::${bucket_name}",
            "arn:${data.aws_partition.current.partition}:s3:::${bucket_name}/*"
          ]
        ])
      }
    ]
  })
}


resource "aws_iam_policy" "assume_etl" {
  name = "service-account-assume-role-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "sts:AssumeRole"
        Resource = aws_iam_role.etl.arn
      }
    ]
  })
}

# Attach S3 grants to the role assumed by the service account
resource "aws_iam_role_policy_attachment" "s3_policy_to_etl" {
  role       = aws_iam_role.etl.name
  policy_arn = aws_iam_policy.s3_bucket_full.arn
}

# Add the policy to assume the role to the user directly
resource "aws_iam_user_policy_attachment" "assume_etl_to_etl" {
  user       = aws_iam_user.etl.name
  policy_arn = aws_iam_policy.assume_etl.arn
}


# Attach S3 grants directly to the user
resource "aws_iam_user_policy_attachment" "s3_policy_full_to_etl" {
  user       = aws_iam_user.etl.name
  policy_arn = aws_iam_policy.s3_bucket_full.arn
}
