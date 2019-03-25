output "eip" {
  value = "${aws_eip.vpn_instance_eip.public_ip}"
}

