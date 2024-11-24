# Output Load Balancer DNS Name
output "web_lb_dns_name" {
  value = aws_lb.web_lb.dns_name
}

# Output Load Balancer DNS Name
output "app_lb_dns_name" {
  value = aws_lb.app_lb.dns_name
}

output "TG_Web" {
  value =aws_lb_target_group.web_tg.arn
}

output "TG_App" {
  value =aws_lb_target_group.app_tg.arn
}