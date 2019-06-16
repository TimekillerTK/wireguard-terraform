# Output variables that need to be defined for post_deploy.sh
output "eip" {
  value = aws_eip.vpn_instance_eip.public_ip
}

output "out_folder" {
  value = var.output_folder
}