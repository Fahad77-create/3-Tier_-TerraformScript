module "Vpc" {
  source = "./modules/VPC"
  vpc_cidr ="10.0.0.0/16"
}

module "Subnet" {
  source = "./modules/Subnet"
  vpc = module.Vpc.VpcMain

  subnets = {
    PublicSub1 = { cidr_block = "10.0.1.0/24", availability_zone = "us-east-1a" }
    PublicSub2 = { cidr_block = "10.0.2.0/24", availability_zone = "us-east-1b" }
    PrivateSub1 = { cidr_block = "10.0.3.0/24", availability_zone = "us-east-1a" }
    PrivateSub2 = { cidr_block = "10.0.4.0/24", availability_zone = "us-east-1b" }
    PrivateSub3 = { cidr_block = "10.0.5.0/24", availability_zone = "us-east-1a" }
    PrivateSub4 = { cidr_block = "10.0.6.0/24", availability_zone = "us-east-1b" }
  }
}

module "Ec2" {
    source = "./modules/EC2"

    instances = {
    web = {
      subnet_id      = module.Subnet.subnet_ids["PublicSub1"]
      security_group = module.Security_groups.Web_Sg  
      name           = "web"
      user_data      = <<-EOF
                      #!/bin/bash
                      yum update -y
                      yum install -y nginx
                      systemctl start nginx
                      systemctl enable nginx
                      EOF
    },
    app = {
      subnet_id      = module.Subnet.subnet_ids["PrivateSub1"]   
      security_group = module.Security_groups.App_sg 
      name           = "app"
      user_data      = <<-EOF
                      #!/bin/bash
                      yum update -y
                      yum install -y nodejs
                      cd /path/to/app
                      npm install
                      pm2 start app.js
                      EOF  
    },
    db = {
      subnet_id      = module.Subnet.subnet_ids["PrivateSub3"]  
      security_group = module.Security_groups.DB_sg  
      name           = "DB"
      user_data      = <<-EOF
                      #!/bin/bash
                      yum update -y
                      yum install -y mysql-server
                      systemctl start mysqld
                      systemctl enable mysqld
                      EOF
    },
  }
}

module "Security_groups" {
  source = "./modules/SecurityGroups"
  Vpc = module.Vpc.VpcMain
}

module "IG" {
  source = "./modules/InternetGateway"
  vpc = module.Vpc.VpcMain
}

module "NAT" {
  source = "./modules/NAT"
  PublicSub = module.Subnet.subnet_ids["PublicSub1"]
}

module "Routes" {
  source = "./modules/Routes"
  vpc = module.Vpc.VpcMain
  IG = module.IG.IG
  NAT = module.NAT.NAT
  publicsubs = {
    Subnet1 = module.Subnet.subnet_ids["PublicSub1"]
    Subnet2 = module.Subnet.subnet_ids["PublicSub2"]
  }
  privatesubs = {
    Subnet1 = module.Subnet.subnet_ids["PrivateSub1"]
    Subnet2 = module.Subnet.subnet_ids["PrivateSub2"]
    Subnet3 = module.Subnet.subnet_ids["PrivateSub3"]
    Subnet4 = module.Subnet.subnet_ids["PrivateSub4"]
  }
}



# This should be in the same module or context where you're outputting the AMIs
locals {
  ami_map = module.Ec2.ami_map  # Assuming the module outputs the ami_map
}

module "LaunchConfig" {
  source = "./modules/AutoScaling"
  Launch_config = {
    web = {
    name       = "web-instance"
    image_id   = module.Ec2.ami_map["web"]
    instance_type  = "t2.micro"  
    security_group = module.Security_groups.Web_Sg
    },

    app = {
    name       = "app-instance"
    image_id   = module.Ec2.ami_map["app"]
    instance_type  = "t2.micro"  
    security_group = module.Security_groups.App_sg
    },
  }
  

  instance_subnets = [ module.Subnet.subnet_ids["PublicSub1"] , module.Subnet.subnet_ids["PrivateSub1"]]

  ami_subnets = [module.Subnet.subnet_ids["PublicSub2"], module.Subnet.subnet_ids["PrivateSub2"] ]

  TargetGroup = [ module.load_balancer.TG_Web , module.load_balancer.TG_App]
}

module "load_balancer" {
  source = "./modules/LoadBalancer"
  vpc = module.Vpc.VpcMain
  web_sg = [module.Security_groups.EXternal_LB]
  web_subnet = [module.Subnet.subnet_ids["PublicSub1"] , module.Subnet.subnet_ids["PublicSub2"]]
  app_sg = [module.Security_groups.Internal_LB]
  app_subnet = [module.Subnet.subnet_ids["PrivateSub1"] , module.Subnet.subnet_ids["PrivateSub2"]]
}

module "DB" {
  source = "./modules/DB"
  db_sg = module.Security_groups.DB_sg
  app_sg = module.Security_groups.App_sg
  subnets = [
    module.Subnet.subnet_ids["PrivateSub3"], module.Subnet.subnet_ids["PrivateSub4"]
  ]
}