resource "aws_internet_gateway" "main" {
  vpc_id = var.vpc

  tags = {
    Name = "MainIGW"
  }
}