# # Launch Configuration
resource "aws_launch_template" "this" {
  for_each         = var.Launch_config
  name_prefix      = each.value.name
  image_id         = each.value.image_id
  instance_type    = each.value.instance_type

  network_interfaces {
    security_groups            = [each.value.security_group]
    associate_public_ip_address = true  # Set to true if public IP is needed, or remove if not
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Auto-scaling Group
resource "aws_autoscaling_group" "this" {
  for_each = aws_launch_template.this

  launch_template {
    id      = aws_launch_template.this[each.key].id
    version = "$Latest"
  }

  target_group_arns = var.TargetGroup

  min_size           = 1
  max_size           = 2
  desired_capacity   = 2

  # Choose the appropriate subnet list based on instance type
  vpc_zone_identifier = each.key == "web" || each.key == "app" || each.key == "db" ? var.instance_subnets : var.ami_subnets

  health_check_type          = "EC2"  # Use EC2 status checks
  health_check_grace_period = 300     # Allow time for instance initialization

  tag {
    key                 = "Name"
    value               = each.key
    propagate_at_launch = true
  }

   lifecycle {
    create_before_destroy = true
  }
}



# resource "aws_launch_configuration" "app_launch_config" {

#   name              = "launch-config-app"
#   image_id          = var.ami
#   instance_type     = var.instance_type
#   security_groups   = [var.security_group]

#   lifecycle {
#     create_before_destroy = true
#   }
# }

