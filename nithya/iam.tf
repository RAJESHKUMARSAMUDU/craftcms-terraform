####################
# IAM Role
####################

resource "aws_iam_role" "codebuild_service_role" {
  name               = "role-codebuild-service-role"
  assume_role_policy = file("./roles/codebuild_assume_role.json")
}

resource "aws_iam_role" "codepipeline_service_role" {
  name               = "role-codepipeline-service-role"
  assume_role_policy = file("./roles/codepipeline_assume_role.json")
}

####################
# IAM Role Policy
####################

resource "aws_iam_role_policy" "codebuild_service_role" {
  name   = "build-policy"
  role   = aws_iam_role.codebuild_service_role.name
  policy = file("./roles/codebuild_build_policy.json")
}

resource "aws_iam_role_policy" "codepipeline_service_role" {
  name   = "pipeline-policy"
  role   = aws_iam_role.codepipeline_service_role.name
  policy = file("./roles/codepipeline_pipeline_policy.json")
}
