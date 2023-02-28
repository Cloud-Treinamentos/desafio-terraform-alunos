variable "sg_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "amis" {
  type = map(any)
  default = {
    us-east-1 = "ami-0149b2da6ceec4bb0"
    us-east-2 = "ami-0d5bf08bc8017c83b"
   # us-west-1 = "ami-03f6d497fceb40069"
  }
}

variable "key" {
  type = map(any)
  default = {
    us-east-1 = "aws_wrs"
    us-east-2 = "aws_desafio2"
  #  us-west-1 = "aws_desafio2w"
  }
}

/*variable dbname {
  description = "db name"
}
*/

/*variable username {
  description = "DB username"
}

variable password {
  description = "DB password"
}*/