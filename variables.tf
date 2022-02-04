
#
# DO NOT DELETE THESE LINES UNTIL INSTRUCTED TO!
#
# Your AMI ID is:
#
#     "ami-00482f016b2410dc8"
#
# Your subnet ID is:
#   

# "subnet-099fb4c8d83446172"

#
# Your VPC security group ID is:
#  

# "sg-00a20c272d565a71f"

#
# Your Identity is:
#
#     "awsaccount"
#


variable "access_key" {
  description = "AWS Access Key"
}

variable "secret_key" {
  description = "AWS Secret Key"
}

variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "ami" {
  description = "Server Image ID"
}

variable "subnet_id" {
  description = "Server Subnet ID"
}

variable "identity" {
  description = "Server Name"
}

variable "vpc_security_group_ids" {
  description = "Server Security Group ID(s)"
  type        = list(any)
}

variable "environment" {
  description = "environment to deploy to"
}