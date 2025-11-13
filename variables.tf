variable "region" {
  type    = string
  default = "us-west-2"
}

variable "az" {
  type    = string
  default = "us-west-2a"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "env_tag" {
  type    = string
  default = "sandbox"
}

variable "key_name" {
  type    = string
  default = "wu-key"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ami_owner" {
  type    = string
  default = "amazon"
}

variable "my_ip" {
  type    = string
  default = "119.73.100.68/32"
}
