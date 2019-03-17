variable "namespace" {
  description = "Prefix for some entities, usually 'something-something'"
  default     = "neko-vpn"
}

variable "environment" {
  description = "Name of environment eg dev/staging/production."
  default     = "prod"
}

variable "keypair_name" {
  description = "Name of keypair on AWS."
  default     = "Neko-VPN"
}

### DNS and CERT

variable "route53_hosted_zone" {
  default = "hosted.zone.here"
}

variable "name_subdomain" {
  default = "namesubdomain"
}

variable "acm_certificate_arn" {
  description = "ARN of ACM certificate created manually."
  default     = "ARNHERE"
}

### REGION & VPC ###

variable "region" {
  description = "AWS Region."
  default     = "eu-west-1"
}

variable "vpc_azs" {
  type        = "list"
  description = "List of AZs for the VPC, must match region."
  default     = ["eu-west-1a", "eu-west-1b"]
}

variable "vpc_cidr_two_octets" {
  description = "First two octets of a /16 CIDR block, eg. '10.10'."
  default     = "10.177"
}

### ECS ###
# Note: If EC2 type is enabled, the agent role-policies might need to be enabled as well, see ecs.tf

variable "ecs_public_instance_type" {
  default = "t2.micro"
}

variable "ecs_public_min_size" {
  default = "0"
}

variable "ecs_public_max_size" {
  default = "0"
}

variable "ami" {
  # eu-west-1: ubuntu AMI	ami-00035f41c82244dab
  description = "AMI to use, must fit region, by default we use latest ECS-Optimized AMI."
  default     = "ami-00035f41c82244dab"
}

### ECS Task & Container ###

variable "service" {
  default = "servicename"
}

variable "app_port" {
  description = "Container port for app."
  default     = "serviceport"
}

variable "app_image" {
  description = "Full name of the server image on ECR."
  default     = "pathtoimage"
}

variable "app_desired_count" {
  description = "The number of replicas app should run."
  default     = "1"
}

variable "app_cpu" {
  default = 2048
}

variable "app_memory" {
  default = 10240
}
