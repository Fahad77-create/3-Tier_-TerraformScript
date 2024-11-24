variable "vpc" {
  
}

variable "web_subnet" {
  type = list(string)
}

variable "web_sg" {
  type = list(string)
}

variable "app_subnet" {
  type = list(string)
}

variable "app_sg" {
  type = list(string)
}