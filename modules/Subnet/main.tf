resource "aws_subnet" "AllSubnets" {
  for_each = var.subnets

  vpc_id            = var.vpc
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name = each.key  
  }
}
