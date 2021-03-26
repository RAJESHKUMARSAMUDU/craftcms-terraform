resource "aws_lb" "craftcms-nlb" {
  name               = "craftcms-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.public-subnet-1.id, aws_subnet.public-subnet-2.id, aws_subnet.public-subnet-2.id]
  ip_address_type    = "ipv4"
  tags = {
    Name = "craftcms-nlb"
  }
}
resource "aws_lb_target_group" "craftcms_tg" {
  name        = "craftcms-tg"
  port        = 80
  protocol    = "TCP"
  target_type = "ip"
  vpc_id      = aws_vpc.craftcms-vpc.id
  depends_on = [
    // Important bit is here
    aws_lb.craftcms-nlb
  ]
}

# Redirect all traffic from the NLB to the target group

resource "aws_lb_listener" "craftcms-nlb" {
  load_balancer_arn = aws_lb.craftcms-nlb.id
  port              = 80
  protocol          = "TCP"
default_action {
    target_group_arn = aws_lb_target_group.craftcms_tg.id
    type             = "forward"
  }
}
