data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]  # Official Ubuntu account ID for Ubuntu images

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

#Ec2
resource "aws_instance" "app_instance" {
  for_each         = var.instances  
  ami              = data.aws_ami.ubuntu.id  
  instance_type    = "t2.micro"              
  key_name         = var.key_name             
  subnet_id        = each.value.subnet_id    
  security_groups  = [each.value.security_group]  

  tags = {
    Name = each.value.name  
  }
}


resource "aws_ami_from_instance" "app_ami" {
  for_each              = aws_instance.app_instance
  name                  = "app-instance-ami-${each.key}"
  source_instance_id    = each.value.id
  snapshot_without_reboot = true  # Avoid rebooting the instance during Ami creation

  tags = {
    Name = "AppInstanceAMI-${each.value.tags["Name"]}"
  }
}  

# resource "aws_eip" "app_eip" {
#   instance = aws_instance.app_instance.id   # Associate the EIP with the EC2 instance
#   vpc      = true
# }
