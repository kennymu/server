
locals {
  service_name = "Automation"
  owner        = "Cloud Team"
  createdby    = "terraform"
}

locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Name        = var.identity
    Environment = var.environment
    createdby = local.createdby
    Service = local.service_name
    Owner   = local.owner
  }
}

locals {
  server_os = {
    "ubuntu_18_04" = data.aws_ami.ubuntu_18_04.image_id
    "ubuntu_20_04" = data.aws_ami.ubuntu_20_04.image_id
    "windows_2019" = data.aws_ami.windows_2019.image_id
  }

  ami = (var.ami != "" ? var.ami : lookup(local.server_os, var.server_os))

}

resource "aws_instance" "web" {
  ami                    = local.ami
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids
  key_name 		 = var.key_name
  tags 		      	 = local.common_tags
}

