variable "vpc" {
  
}

variable "IG" {
  
}

variable "NAT" {
  
}

variable "publicsubs" {
  type = map(string)  # A map of subnet IDs as strings
  default = {
    Subnet1 = ""
    Subnet2 = ""
  }
}

variable "privatesubs" {
  type = map(string)  # A map of subnet IDs as strings
  default = {
    Subnet1 = ""
    Subnet2 = ""
    Subnet3 = ""
    Subnet4 = ""
  }
}