output "ami_map" {
  value = { for key, ami in aws_ami_from_instance.app_ami : key => ami.id }
  description = "Map of instance names to their AMI IDs"
}
