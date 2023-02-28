#Insira o Diretório para acessar o arquivo com as credenciais de acesso a AWS
variable "CredentialsDir" {
  default = "/home/czorn/.aws/credential.txt"  
}

# Route53 Insira o seu domínio
variable "Domain" {
  default = "czornoff.ga"
}

#Tags Globais
variable "GlobalTag" {
  default = ["Production,ProjetoDesafio02,Grupo4"]
}

#EC2
variable "InstanceType" {
  default = "t2.micro"
}

#VPC
data "aws_availability_zones" "available" {}

variable "CIDR-VPC" {
  type    = string
  default = "10.0.0.0/16"
}

variable "Internet" {
  type    = string
  default = "0.0.0.0/0"
}

variable "VPCName" {
  type    = string
  default = "Grupo4-Desafio2"
}
variable "aws_region" {
  default     = "us-east-1"
  description = "aws region where our resources going to create choose"
  #replace the region as suits for your requirement
}

#RDS 
variable "dbInstance" {
  default     = "Modelo de instância do RDS"
  description = "db.t3.micro"
}
variable "Engine" {
  default     = "Tipo de engine da db"
  description = "mysql"
}
variable "EngineVersion" {
  default = "5.7"
}

#ECS
variable "ecs_task_execution_role" {
  default     = "myECcsTaskExecutionRole"
  description = "ECS task execution role name"
}