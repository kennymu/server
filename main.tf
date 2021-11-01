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

variable "server_os" {
  type        = string
  description = "Server Operating System"
  default     = "ubuntu_20_04"
}

locals {
  servers = {
    server-iis = {
      server_os              = "windows_2019"
      identity               = "$var.identity-windows"
      subnet_id              = var.subnet_id
      vpc_security_group_ids = var.vpc_security_group_ids
    },
    server-apache = {
      server_os              = "ubuntu_20_04"
      identity               = "$var.identity-ubuntu"
      subnet_id              = var.subnet_id
      vpc_security_group_ids = var.vpc_security_group_ids
    }
  }
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

data "terraform_remote_state" "ssh-keys" {
  backend = "remote"

  config = {
    hostname = "app.terraform.io"
    organization = "example-org-5a4eda"

    workspaces = {
      name = "ssh-keys"
    }
  }
}

module "server" {
  source                 = "app.terraform.io/example-org-5a4eda/server/aws"
  version                = "0.0.1"
  for_each               = local.servers
  server_os              = each.value.server_os
  identity               = each.value.identity
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = each.value.vpc_security_group_ids
  key_name               = data.terraform_remote_state.ssh-keys.outputs.key_name
}

variable "bucket" {}
variable "acl" {}

module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.7.0"

  bucket = var.bucket
  acl    = var.acl

  versioning = {
    enabled = true
  }
}

output "public_ip" {
  description = "Public IP of the Servers"
  value       = { for p in sort(keys(local.servers)) : p => module.server[p].public_ip }
}

output "public_dns" {
  description = "Public DNS names of the Servers"
  value       = { for p in sort(keys(local.servers)) : p => module.server[p].public_dns }
}