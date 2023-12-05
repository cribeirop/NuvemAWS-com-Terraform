variable "ami_id" {
  type    = string
  # default = "ami-0230bd60aa48260c6"
}

variable "instance_type" {
  type    = string
  # default = "t2.micro"
}

variable "key_name" {
  type    = string
  # default = "caiorp"
}

variable "security_group_id" {
  type    = string
  default = "sg-068f536c4752a6690"
}

variable "instance_count" {
  type    = number
  default = 1
}

variable "vpc_id" {
  type    = string
}

variable "public_us_east_1a_id" {
  type    = string
}

variable "public_us_east_1b_id" {
  type    = string
}

variable "private_us_east_1a_id" {
  type    = string
}

variable "private_us_east_1b_id" {
  type    = string
}

variable "ec2_eg1_sg_id" {
  type    = string
}

variable "alb_eg1_sg_id" {
  type    = string
}