variable "region" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_name" {
  type = string
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "public_key_name" {
  type = string
}

variable "public_key_path" {
  type = string
}

