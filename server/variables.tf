
variable "ami" {
  description = "amazon server image"
  default     = ""
}

variable "subnet_id" {
  description = "Subnet Id"
}

variable "vpc_security_group_ids" {
  description = "Security Groups"
  type        = list(any)
}

variable "key_name" {
  description = "SSH Key"
  default     = ""
}

variable "identity" {
  description = "Server Name"
}

variable "environment" {
  description = "Deployment Environment"
  default     = "development"
}

variable "server_os" {
  type        = string
  description = "Server Operating System"
  default     = "ubuntu_20_04"

  validation {
    condition     = contains(["ubuntu_20_04", "ubuntu_18_04", "windows_2019"], lower(var.server_os))
    error_message = "You must use an approved operating system. Options are ubuntu_18_04, ubuntu_20_04, or windows_2019."
  }
}

