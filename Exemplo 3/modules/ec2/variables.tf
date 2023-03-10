variable "aws_region" {}
variable "project_name" {}
variable "course_name" {}
variable "efs_id" {}
variable "rds_endpoint" {}
variable "db_name" {}
variable "db_user" {}
variable "db_password" {}
variable "subnet_pub1" {}
variable "sg_ec2" {}
variable "tags" {}

variable "ec2_instance_type" {
  type        = string
  description = ""
  default     = "t2.micro"
}

variable "monitoring" {
  description = "Se verdadeiro, a instância do EC2 iniciada terá o monitoramento detalhado ativado"
  type        = bool
  default     = true
}

variable "key_name" {
  type        = string
  description = ""
  default     = "devops"
}