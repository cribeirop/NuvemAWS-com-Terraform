variable "vpc_id" {
  type    = string
}

variable "private_us_east_1a_id" {
  type    = string
}

variable "private_us_east_1b_id" {
  type    = string
}

variable "db_username" {
    type    = string
}

variable "db_password" {
    type    = string
    sensitive = true
}

variable "rds_sg_id" {
    type    = string
}

variable "db_name" {
    type    = string
}