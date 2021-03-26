output "aws_ecr_repository_url" {
  value = aws_ecr_repository.main.repository_url
}


output "alb_hostname" {
  value = aws_lb.craftcms-nlb.dns_name
}
