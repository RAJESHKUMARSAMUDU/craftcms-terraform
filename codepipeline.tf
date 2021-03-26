resource "aws_codepipeline" "craft-cms" {
  name     = "pipeline-fargate-deploy"
  role_arn = aws_iam_role.codepipeline_service_role.arn

  artifact_store {
    location = aws_s3_bucket.craft-cms-test-ecs.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner                = "RAJESHKUMARSAMUDU"
        Repo                 = "craft-cms"
        Branch               = "master"
        OAuthToken           = var.webhook_secret
        PollForSourceChanges = "false"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName   = aws_codebuild_project.craft-cms.name
        PrimarySource = "Source"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ClusterName = aws_ecs_cluster.craftcms.arn
        ServiceName = aws_ecs_service.craftcms.name
        FileName    = "imagedefinitions.json"
      }
    }
  }
}

resource "aws_codepipeline_webhook" "craft" {
  name            = "webhook-fargate-deploy"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.craft-cms.name

  authentication_configuration {
    secret_token = var.webhook_secret
  }

  filter {
    json_path    = "$.ref"
    match_equals = "refs/heads/{Branch}"
  }
}

resource "github_repository_webhook" "craft" {
  repository = "craft-cms"
  configuration {
    url          = aws_codepipeline_webhook.craft.url
    content_type = "json"
    insecure_ssl = false
    secret       = var.webhook_secret
  }

  events = ["push"]
}

