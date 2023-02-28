variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default     = "172.16.0.0/16"
}
variable "public_key_path" {
  description = "Public key path"
  default     = "./chave_ssh.pub"
}
variable "public_key_name" {
  description = "Public key name"
  default     = "chave_ssh.pub"
}

 variable "instance_ami" {
  description = "AMI for aws EC2 instance"
  default     = "ami-0149b2da6ceec4bb0"
}

# variable "instance_ami" {
#   type = map
#   description = "AMI for aws EC2 instance"
#   default     = {
#     "us-east-1" = "ami-0149b2da6ceec4bb0"
#     "sa-east-1" = "ami-054a31f13bbf90920"
#   }
#}

variable "instance_type" {
  description = "type for aws EC2 instance"
  default     = "t2.micro"
}
variable "vpc_name" {
  description = "Nome para a VPC"
  default     = "vpc_desafio_2"
}

variable "certificate_arn" {
  description = "ARN do Certificado"
  default = "arn:aws:acm:us-east-1:834037870590:certificate/788943e3-b86a-4777-b83c-d2f1979a9d19"
  
}

#PARA USO COMO CI/CD GitLab
# variable "aws_pub_key" {
#   description = "Public key para VM na AWS"
#   type = string
# }
