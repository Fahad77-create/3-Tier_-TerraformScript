
############################## EXternal_LB #################

resource "aws_security_group" "ExternalLB" {
  name        = "ExternalLB-security-group"
  description = "Basic security group"
  vpc_id      = var.Vpc

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ssh traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["111.88.218.198/32"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ExternalLB-sg"
  }
}

############################## Web_Sg ###############################

resource "aws_security_group" "Web_Sg" {
  name        = "Web_Sg-security-group"
  description = "Basic security group"
  vpc_id      = var.Vpc

  ingress {
    description = "Allow ExternalLB traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups =[aws_security_group.ExternalLB.id] 
  }

 ingress {
    description = "Allow my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["111.88.218.198/32"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-sg"
  }
}

############################## Internal_LB ###############################

resource "aws_security_group" "Internal_LB" {
  name        = "Internal_LB-security-group"
  description = "Basic security group"
  vpc_id      = var.Vpc

  ingress {
    description = "Allow Web traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups =[aws_security_group.Web_Sg.id] 
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Internal_LB-sg"
  }
}

############################## App_sg ###############################

resource "aws_security_group" "App_sg" {
  name        = "App_sg-security-group"
  description = "Basic security group"
  vpc_id      = var.Vpc

  ingress {
    description = "Allow Internal_LB traffic"
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    security_groups =[aws_security_group.Internal_LB.id] 
  }

  ingress {
    description = "Allow my ip"
    from_port   = 4000
    to_port     = 4000
    protocol    = "tcp"
    cidr_blocks = ["111.88.218.198/32"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "App_sg-sg"
  }
}

############################## DB_sg ###############################

resource "aws_security_group" "DB_sg" {
  name        = "DB_sg-security-group"
  description = "Basic security group"
  vpc_id      = var.Vpc

  ingress {
    description = "Allow App traffic"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups =[aws_security_group.App_sg.id] 
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DB_sg-sg"
  }
}