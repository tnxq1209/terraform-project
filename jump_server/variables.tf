variable "region" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "public_key_name" {
  type = string
}

variable "public_key_path" {
  type = string
}

variable "s3_bucket_name" {
  type = string
}

variable "ssh_private_key_file" {
  description = "Absolute path to the jump server SSH private key on the local machine"
  type        = string
}