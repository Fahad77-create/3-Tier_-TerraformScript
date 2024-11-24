variable "key_name" {
  type = string
  default = "Key2"
}

variable "instances" {
  description = "Map of instance configurations"
  type = map(object({
    subnet_id       = string
    security_group  = string
    name            = string  # Add name for the instance
    user_data       = string
  }))
  default = {
  web = {
      subnet_id      = ""
      security_group = ""
      name           = "web-instance"
      user_data      = <<-EOF
                      #!/bin/bash
                      yum update -y
                      yum install -y nginx
                      systemctl start nginx
                      systemctl enable nginx
                      EOF
    },
    app = {
      subnet_id      = ""
      security_group = ""
      name           = "app-instance"
      user_data      = <<-EOF
                      #!/bin/bash
                      yum update -y
                      yum install -y nodejs
                      cd /path/to/app
                      npm install
                      pm2 start app.js
                      EOF
    },
    DB = {
      subnet_id      = ""
      security_group = ""
      name           = "db-instance"
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