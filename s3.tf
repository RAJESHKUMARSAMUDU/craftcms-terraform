resource "aws_s3_bucket" "craft-cms-test-ecs" {
  bucket = "craft-cms-test-ecs"
  acl    = "private"
}
