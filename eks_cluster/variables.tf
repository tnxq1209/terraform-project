variable "project" {
  type = object({
    name        = string
    environment = string
    region      = string
  })
}

variable "vpc_cidr" {

  type = string

  validation {

    condition = can(cidrhost(var.vpc_cidr, 0))

    error_message = "Invalid CIDR block."

  }

}
