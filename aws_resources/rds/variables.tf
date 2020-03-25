variable "vpc" {
  default = "vpc-05286d0ec3cfda599" # main vpc
}

variable "region" {
  default = "us-west-2" # Oregon
}

variable "prefix" {
  default = "hkw"
}

variable "subnets" {
  default = ["subnet-0e00630442db9b6b1", # us-west-2b
             "subnet-062d1eb22fd53730c"] # us-west-2c
}
