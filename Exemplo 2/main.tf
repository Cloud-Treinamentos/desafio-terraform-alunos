terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.36.1"
    }
  }

  ### CRIAR O BACKEND PARA SALVAR O TFSTATE ####
  backend "s3" {
    bucket = "bucket-magno-terraform"
    key    = "desafio-02/terraform.tfstate"
    region = "us-east-1"
  }

}
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      owner      = "Grupo-03-DevOps"
      managed-by = "Terraform"
    }
  }
}

### CRIAR O PAR DE CHAVES PARA USAR NAS INSTANCIAS ####
# resource "aws_key_pair" "ec2key" {
#   key_name   = var.public_key_name
#   public_key = file(var.public_key_path)
#   #public_key = file(var.aws_pub_key) #para usar pelo CI/CD
# }

### CRIAR O PAR DE CHAVES PARA USAR NAS INSTANCIAS ####
resource "tls_private_key" "private_key" {
algorithm = "RSA"
}
# Generate a key-pair with above key
resource "aws_key_pair" "chave_ssh" {
key_name   = "chave_ssh"
public_key = tls_private_key.private_key.public_key_openssh
}

# Saving Key Pair for ssh login for Client if needed
resource "null_resource" "save_key_pair"  {
provisioner "local-exec" {
command = "echo  ${tls_private_key.private_key.private_key_pem} > chave_ssh_private.pem"
}
}

### PARA USO DE CHAVES CRIADAS PELO AWS CLI ####
# provider "aws" {
#   region     = "us-east-1"
#   access_key = "my-access-key"
#   secret_key = "my-secret-key"
# }

### SCRIPT PARA RODAR NAS INSTANCIAS ###
data "template_file" "script" {
  template = file("./script.tpl")
  vars = {
    efs_id = "${aws_efs_file_system.efs.dns_name}"
  }
}

### CRIAR O TEMPLATE DE CONFIGURAÇÃO A SER USADO NO AUTO SCALING ####
resource "aws_launch_configuration" "wordpress" {
  name_prefix                 = "Config-Exec"
  image_id                    = var.instance_ami
  #image_id                    = lookup(var.instance_ami, us-east-1)
  instance_type               = var.instance_type
  security_groups             = ["${aws_security_group.instance_sg.id}"]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.chave_ssh.key_name
  #key_name                    = aws_key_pair.ec2key.key_name
  user_data                   = data.template_file.script.rendered
  lifecycle {
    create_before_destroy = true
  }
}

### CRIAR O CERTIFICADO #### - FOI CRIADO MANUALMENTE E IMPORTADO PARA O TERRAFORM

#  data "aws_acm_certificate" "certificate" {
#    domain            = "marisastore.emmatech.com.br"
#    statuses          =["ISSUED"]
#    most_recent       = true
#   #  validation_method = "DNS"
#   #    tags = {
#   #    #Environment = "Certificado-Marisa-Store"
#   #  }

#   #  lifecycle {
#   #    create_before_destroy = true
#   #  }
#  }



