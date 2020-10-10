variable "aws_region" {
   type        = string
   description = "The AWS region to create the environment."
   default     = "us-east-1"
}

variable "enable_nat_gw" {
   type        = bool
   description = "Enable NAT gateway deployment? AWS may charge you for this."
   default     = false
}

variable "ssh_access_cidr" {
   type        = list
   description = "List of CIDR for SSH access to public/private subnet."
   default     = [ "0.0.0.0/0" ]
}

variable "project_name" {
   type        = string
   description = "The name of your project."
   default     = "demo"
}

locals {
   base_tags = {
      Team        = "DevOps"
      Project     = var.project_name
   }
}