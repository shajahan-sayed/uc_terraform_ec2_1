variable "aws_region" {
  description = "aws region to deploy resource"
  type = string
}

variable "instance_type" {
  description = "instance type to create ec2"
  type = string
}

variable "ami_id" {
  description = "ami_id to create ec2"
  type = string
}

variable "key_name" {
  description = "key_name to create ec2"
  type = string
}

variable "vpc_cidr" {
  description = "ami_id to create ec2"
  type = string
}

variable "subnet_cidr" {
  description = "attaching cidr for subnet"
  type = string
}

variable "availability_zone" {
  description = "Availability zone for subnet"
  type        = string
}
