terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  # Perfil das chaves
  profile = "terraform"
  # Região de arazemanemtno
  region  = "us-east-1"
}

# Variável. Poderia ser criado em um arquivo variables.tf
variable "website_root" {
  type        = string
  description = "Conteudo de armazenamento"
  default     = "content"
}
#Cria bucket chamado host-static-websiteandrev2 - Deve ser modificado!
resource "aws_s3_bucket" "website" {
  bucket = "host-static-websiteandrev2-pack"
  object_lock_enabled = false
}
#Configura o acesso para impedir o acesso direto
resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.website.bucket
  acl    = "private"
}
#Estabelece que o bucket irá servir um website estático
resource "aws_s3_bucket_website_configuration" "website_conf"{
    bucket = aws_s3_bucket.website.bucket
    index_document {
      suffix = "index.html"
    }
}

#Para permitir a configuração e envio dos arquivos
locals {
  website_files = fileset(var.website_root, "**")

  mime_types = jsondecode(file("types.json"))
}

resource "aws_s3_object" "file" {
  for_each = fileset(var.website_root, "**")

  bucket      = aws_s3_bucket.website.id
  key         = each.key
  source      = "${var.website_root}/${each.key}"
  source_hash = filemd5("${var.website_root}/${each.key}")
  acl         = "public-read"
  content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.key), null)
}

# Exibir o endpoint. Poderia ser criado o arquivo outputs.tf
output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.website_conf.website_endpoint
}