output "subnet_ids" {
  value = { for key, subnet in aws_subnet.AllSubnets: key => subnet.id }
  description = "Map of subnet names to their IDs"
}