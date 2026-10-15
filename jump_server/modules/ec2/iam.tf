
resource "aws_iam_role" "jumpserver" {
  name = "devops-jumpserver-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.common_tags
}

# Allow the jump server to discover EKS clusters.
resource "aws_iam_role_policy" "eks_discovery" {
  name = "eks-cluster-discovery"
  role = aws_iam_role.jumpserver.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:ListClusters",
          "eks:DescribeCluster"
        ]
        Resource = "*"
      },
      {
        # Bucket-level permissions (Listing files)
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = [
          var.bucket_arn
        ]
      },
      {
        # Object-level permissions (Uploading, Downloading, Deleting)
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "${var.bucket_arn}/*"
        ]
      }
    ]
  })
}

# EC2 attaches IAM roles through instance profiles.
resource "aws_iam_instance_profile" "jumpserver" {
  name = "devops-jumpserver-profile"
  role = aws_iam_role.jumpserver.name

  tags = var.common_tags
}
