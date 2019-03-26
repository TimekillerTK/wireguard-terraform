# For testing purposes - improper value was being returned from local_exec 
# Delete later
output "eip" {
  value = "${aws_eip.vpn_instance_eip.public_ip}"
}

