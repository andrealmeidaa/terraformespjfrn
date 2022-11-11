variable "region" {
  description = "AWS Region"
  default = "us-east-1"
}

variable "key_path" {
  description = "Public key path"
  default = ""#Chave pública para acesso via ssh
}

variable "ami" {
  description = "AMI"
  default = "ami-09d3b3274b6c5d4aa" // Amazon Linux
}

variable "instance_type" {
  description = "EC2 instance type"
  default = "t2.micro"
}

variable "perfil"{
  description = "Perfil com credenciais da AWS"
  value="terraform"
}