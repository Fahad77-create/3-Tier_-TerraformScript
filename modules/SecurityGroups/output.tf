
output "EXternal_LB" {
  value = aws_security_group.ExternalLB.id
}

output "Web_Sg" {
  value = aws_security_group.Web_Sg.id
}

output "Internal_LB" {
  value = aws_security_group.Internal_LB.id
}

output "App_sg" {
  value = aws_security_group.App_sg.id
}

output "DB_sg" {
  value = aws_security_group.DB_sg.id
}