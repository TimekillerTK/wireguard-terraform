# Allocating EIP to nw interface
resource "aws_eip_association" "vpn_eip_assoc" {
  network_interface_id = aws_network_interface.vpn_nw_int.id
  allocation_id        = aws_eip.vpn_instance_eip.id

  depends_on = [module.vpc]
}

### Network Interfaces and Instances

# Interface 0
resource "aws_network_interface" "vpn_nw_int" {
  # eg. 10.*.1.10
  description = "Interface for L0 instance"
  subnet_id   = element(module.vpc.public_subnets, 0)
  private_ips = [cidrhost(element(module.vpc.public_subnets_cidr_blocks, 0), 10)]

  security_groups = [aws_security_group.vpc_default.id]

  tags = {
    "Terraform"   = "true"
    "Environment" = var.environment
    "Name"        = "${var.environment}-int-0"
  }
}

data "template_file" "vpn_user_data" {
  template = file("${path.module}/files/wireguard.sh")

  vars = {
    # broken server_ip (fix later) 
    server_ip     = "10.177.101.10"
    allowed_ip    = "${cidrhost(element(module.vpc.public_subnets_cidr_blocks, 0), 20)}/32"
    client_pubkey = var.client_pub_key
    hostname      = "${var.namespace}-${var.environment}-ec2-instance"
    environment   = var.environment
  }
}

resource "aws_instance" "vpn_instance" {
  ami               = var.ami
  instance_type     = var.instance_type
  availability_zone = element(var.vpc_azs, 0)
  key_name          = var.keypair_name

  user_data = data.template_file.vpn_user_data.rendered

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }

  network_interface {
    network_interface_id = aws_network_interface.vpn_nw_int.id
    device_index         = 0
  }

  tags = {
    "Terraform"   = "true"
    "Environment" = var.environment
    "Name"        = "${var.environment}-ec2-instance"
  }
  # Running post-deploy script which pulls data from the instance
  # Old and deprecated, this code will be run in run_script.sh instead
  #provisioner "local-exec" {
  #  command = "sleep 90 && sh ./files/post_deploy.sh"
  #}
}

