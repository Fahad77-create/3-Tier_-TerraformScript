# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"  
}


# NAT Gateway in the public subnet
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.PublicSub

  tags = {
    Name = "main-nat-gateway"
  }
}