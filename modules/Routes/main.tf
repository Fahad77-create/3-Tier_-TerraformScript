resource "aws_route_table" "IG_route" {
  vpc_id = var.vpc

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.IG     
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table_association" "IG_route_Association" {
for_each = var.publicsubs
  subnet_id      = each.value           
  route_table_id = aws_route_table.IG_route.id    
}

# NAT route
resource "aws_route_table" "NAT_route" {
  vpc_id = var.vpc

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.NAT     
  }

  tags = {
    Name = "PrivateRouteTable"
  }
}

resource "aws_route_table_association" "NAT_route_Association" {
  for_each = var.privatesubs
  subnet_id      = each.value             
  route_table_id = aws_route_table.NAT_route.id  
}