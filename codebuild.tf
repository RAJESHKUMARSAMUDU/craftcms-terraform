resource "aws_codebuild_project" "craft-cms" {
  name         = "craft-cms-fargate-deploy"
  description  = "craft-cms-fargate-deploy"
  service_role = aws_iam_role.codebuild_service_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:2.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = "us-east-1"
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = "706205005497"
    }

    environment_variable {
      name  = "IMAGE_REPO_NAME_NGINX"
      value = "craftcms-terraform"
    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }

  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/RAJESHKUMARSAMUDU/craft-cms.git"
    git_clone_depth = 1
    buildspec       = "buildspec.yml"
  }
  vpc_config {
    vpc_id = aws_vpc.craftcms-vpc.id
 
    subnets = [
      aws_subnet.private-subnet-1.id,
      aws_subnet.private-subnet-2.id
    ]
 
    security_group_ids = [
      aws_security_group.craftcms-service.id,
    ]
  }

}

