# variable "security_groups" {
#   type = map(string) 
#   # default     = local.ami_map  # A map of AMI keys to their respective security group IDs
# }


# variable "ami" {
#   description = "Map of instance names to their AMI IDs"
#   type        = map(string)
#   default     = local.ami_map  # Set the default value to the local ami_map
# }

# variable "subnet" {
  
# }



# variable "name" {
#   description = "Name of the ASG"
#   type        = string
# }

# variable "ami" {
#   description = "Map of instance names to their AMI IDs"
#   type        = string
# }

# variable "instance_type" {
#   description = "EC2 instance type"
#   type        = string
#   default     = "t2.micro"
# }

# variable "security_group" {
#   description = "Security group ID for instances"
#   type        = string
# }

# variable "subnets" {
#   description = "List of subnet IDs for the ASG"
#   type        = list(string)
# }

# variable "min_size" {
#   description = "Minimum number of instances"
#   type        = number
# }

# variable "max_size" {
#   description = "Maximum number of instances"
#   type        = number
# }

# variable "desired_capacity" {
#   description = "Desired number of instances"
#   type        = number
# }


variable "Launch_config" {
  description = "Map of configurations"
  type = map(object({
    name       = string
    image_id   = string
    instance_type  = string  
    security_group = string
  }))

  default = {
  web = {
    name       = ""
    image_id   = ""
    instance_type  = ""  
    security_group = ""
    },

    app = {
    name       = ""
    image_id   = ""
    instance_type  = ""  
    security_group = ""
    },

  }
}

variable "instance_subnets" {
  type    = list(string)
    # Replace with actual instance subnet IDs
}

variable "ami_subnets" {
  type    = list(string)
}

variable "TargetGroup" {
  type = list(string)
}