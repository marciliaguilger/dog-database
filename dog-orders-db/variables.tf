variable "rds_subnet_group_name" {
  description = "Trds subnet group name"
  type        = string
  default     = "rds-subnet-group"
}

variable "rds_sg_id" {
  description = "rds security group id"
  type        = string
  default     = "sg-<ID>"
}