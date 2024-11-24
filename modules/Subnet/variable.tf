variable "vpc" {

}

variable "subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  
  default = {
    "PublicSub1" = { cidr_block = "", availability_zone = "" }
    "PublicSub2" = { cidr_block = "", availability_zone = "" }
    "PrivateSub1" = { cidr_block = "", availability_zone = "" }
    "PrivateSub2" = { cidr_block = "", availability_zone = "" }
    "PrivateSub3" = { cidr_block = "", availability_zone = "" }
    "PrivateSub4" = { cidr_block = "", availability_zone = "" }
  }
}

