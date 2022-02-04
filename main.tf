provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

module "server" {
  count                  = 2
  source                 = "app.terraform.io/example-org-5dcc43/server/aws"
  version                = "0.0.3"
  environment            = var.environment
  ami                    = var.ami
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  identity               = var.identity
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
  value = module.server.*.public_ip
}

output "public_dns" {
  value = module.server.*.public_dns
}

