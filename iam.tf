resource "aws_iam_role" "tf_codepipeline_role" {
  name = "tf-codepipeline-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name        = "Terraform CodePipeline IAM Role"
    Environment = "development"
    Owner       = "smarchman"
    terraform   = "true"
  }
}

data "aws_iam_policy_document" "tf-cicd-codepipeline-policies" {
  statement {
    sid       = ""
    actions   = ["codestar-connections:UseConnection"]
    resources = ["*"]
    effect    = "Allow"
  }
  statement {
    sid       = ""
    actions   = ["cloudwatch:*", "s3:*", "codebuild:*"]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "tf-cicd-pipeline-policy" {
  name        = "tf-cicd-pipeline-policy"
  path        = "/"
  description = "Pipeline Policy"
  policy      = data.aws_iam_policy_document.tf-cicd-codepipeline-policies.json
}

resource "aws_iam_role_policy_attachment" "tf-cicd-pipeline-attachment" {
  policy_arn = aws_iam_policy.tf-cicd-pipeline-policy.arn
  role       = aws_iam_role.tf_codepipeline_role.id
}

resource "aws_iam_role" "tf-codebuild-role" {
  name = "tf-codebuild-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name        = "Terraform CodeBuild IAM Role"
    Environment = "development"
    Owner       = "smarchman"
    terraform   = "true"
    terragrunt  = "maybe next week"
  }
}

data "aws_iam_policy_document" "tf-cicd-build-policies" {
  statement {
    sid       = ""
    actions   = ["logs:*", "s3:*", "codebuild:*", "secretsmanager:*", "iam:*"]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "tf-cicd-build-policy" {
  name        = "tf-cicd-build-policy"
  path        = "/"
  description = "Codebuild Policy"
  policy      = data.aws_iam_policy_document.tf-cicd-build-policies.json
}

resource "aws_iam_role_policy_attachment" "tf-cicd-codebuild-attachment1" {
  policy_arn = aws_iam_policy.tf-cicd-build-policy.arn
  role       = aws_iam_role.tf-codebuild-role.id
}

resource "aws_iam_role_policy_attachment" "tf-cicd-codebuild-attachment2" {
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
  role       = aws_iam_role.tf-codebuild-role.id
}