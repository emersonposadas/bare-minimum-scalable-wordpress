variable "vpc" {
  default = "vpc-05286d0ec3cfda599" # main vpc
}

variable "region" {
  default = "us-west-2" # Oregon
}

variable "instance_type" {
  default = "t3a.small"
}

variable "ami" {
  default = "ami-0a907f9094c2f852e" # hkw_2020-03-16-1584354791
}

variable "prefix" {
  default = "hkw"
}

variable "max_size" {
  default = "4"
}

variable "min_size" {
  default = "1"
}

variable "max_memory" {
  default = "60"
}

variable "min_memory" {
  default = "49"
}
