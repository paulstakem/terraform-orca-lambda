variable "function_name" {}
variable "orca_role" {}
variable "security_group_ids" {
  description = "Security Group"
  type        = list(string)
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet ids"
}
variable "vpc_id" {}