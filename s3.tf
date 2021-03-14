resource "aws_s3_bucket" "codepipeline_artifacts" {
  bucket = "aws-cicd-codepipeline-artifacts-tf-2021"
  acl    = "private"

  tags = {
    Name        = "CodePipeline CICD Artifacts"
    Environment = "development"
    Owner       = "smarchman"
    terraform   = "true"
  }
}