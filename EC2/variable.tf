variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "private_key_path" {}

variable "key_name" {}

variable "region" {
  default = "eu-west-2"
}

variable "vpc_address_space" {
  default = "10.1.0.0/16"
}

variable "subnet1_address_space" {
  default = "10.1.0.0/24"
}

variable "subnet2_address_space" {
  default = "10.1.1.0/24"
}