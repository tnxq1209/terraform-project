variable "region" {
  type = string
}

variable "vpc_id" {
  description = "vpc_id from networking module"
  type = string  
}

variable "public_key_name" {
  type = string
}

variable "user_data_file" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "public_key_path" {
  type = string
}

variable "common_tags" {
  type =map(string)
}

variable "security_groups" {
  type = map(string)
}

variable "instance_type" {
  type = map(string)
}

variable "ingress_rules" {
  description = "Ingress rules for the security group."
  type = list(object({
      description = string
      port = number
      protocol = string
      cidr_blocks = list(string)
    
  }))
}