# create load balancer
resource "aws_lb" "server_lb" {
  name               = "server-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.lb_sg]
  subnets            = [var.public_subnet1_id, var.public_subnet2_id]

  enable_deletion_protection = true


  tags = {
    name = "${var.project_name}-lb"
  }
}
# create target group for load balancer
resource "aws_lb_target_group" "target" {
  name     = "lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    path                = "/"
    interval            = 10
    matcher             = 300
    timeout             = 3
    healthy_threshold   = 3
    unhealthy_threshold = 2
    protocol            = "HTTP"
    port                = "traffic-port" 
  }
}

# certificate
data "aws_acm_certificate" "amazon_issued" {
  domain      = "*.ojowilliamsdaniel.online"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}
# create load balancer listener
resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.server_lb.arn
    port              = "80"
    protocol          = "HTTP"
   

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.target.arn
    }
}