# Define the Target Group
resource "aws_lb_target_group" "web_tg" {
  name     = "Web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc  

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    path                = "/health"
    matcher             = "200"
  }
}

# Define the Application Load Balancer
resource "aws_lb" "web_lb" {
  name               = "Web-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.web_sg  
  subnets            = var.web_subnet  

  enable_deletion_protection = false
}

# Define a Listener for the Load Balancer
resource "aws_lb_listener" "web_lb_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

##########################################################################


# Define the Target Group
resource "aws_lb_target_group" "app_tg" {
  name     = "app-target-group"
  port     = 4000
  protocol = "HTTP"
  vpc_id   = var.vpc  

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    path                = "/health"
    matcher             = "200"
  }
}

# Define the Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "app-load-balancer"
  internal           = true
  load_balancer_type = "application"
  security_groups    = var.app_sg  
  subnets            = var.app_subnet  

  enable_deletion_protection = false
}

# Define a Listener for the Load Balancer
resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
