module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.namespace}-${var.environment}"
  cidr = "${var.vpc_cidr_two_octets}.0.0/16"
  azs  = "${var.vpc_azs}"

  private_subnets = [
    "${var.vpc_cidr_two_octets}.1.0/24",
  ]

  public_subnets = [
    "${var.vpc_cidr_two_octets}.101.0/24",
  ]

  enable_nat_gateway = false

  # These tags apply to all resources
  tags {
    "Terraform"   = "true"
    "Environment" = "${var.environment}"
  }
}

resource "aws_security_group" "vpc_default" {
  name        = "${var.namespace}-${var.environment}-vpc-default"
  description = "Public traffic for VPN"
  vpc_id      = "${module.vpc.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    self      = true
    from_port = 0
    to_port   = 0
    protocol  = "-1"
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["${var.vpc_cidr_two_octets}.0.0/16", "${var.client_pub_ip}"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    "Terraform"   = "true"
    "Environment" = "${var.environment}"
    "Name"        = "${var.namespace}-${var.environment}-vpc-default"
  }
}

resource "aws_eip" "vpn_instance_eip" {
  vpc      = true
  instance = "${aws_instance.vpn_instance.id}"

  depends_on = ["module.vpc"]
}
