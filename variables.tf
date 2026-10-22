variable "instance_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "region" {
  type = string
}

variable "owner" {
  type = string
}

variable "ami" {
  type    = string
  default = "ami-08c46876c64a927b8"
}

variable "docker_image" {
  type = string
}

variable "app_ingress_cidr" {
  type    = string
  default = "0.0.0.0/0"
}
