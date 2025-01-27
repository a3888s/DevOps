# Налаштування AWS провайдера
provider "aws" {
  region  = var.region                       # Регіон AWS для розгортання інфраструктури
  profile = var.iam_profile                  # Профіль AWS для уникнення використання root-акаунту
}

# Налаштування провайдера Kubernetes
provider "kubernetes" {
  host                   = aws_eks_cluster.danit.endpoint                        # Адреса API-сервера Kubernetes
  cluster_ca_certificate = base64decode(aws_eks_cluster.danit.certificate_authority.0.data) # Сертифікат авторизації кластера
  token                  = data.aws_eks_cluster_auth.danit.token                # Токен для автентифікації
}

# Отримання доступних зон доступності AWS
data "aws_availability_zones" "available" {}

# Провайдер HTTP (закоментовано, може бути використаний для додаткових налаштувань)
# provider "http" {}

# Закоментовані вимоги Terraform (можуть бути використані для додаткових залежностей)
# terraform {
#   required_version = ">= 0.13"
#
#   required_providers {
#     kubectl = {
#       source  = "gavinbunney/kubectl"
#       version = ">= 1.7.0"
#     }
#   }
# }

# Налаштування провайдера Helm для роботи з Kubernetes
provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.danit.endpoint                        # Адреса API-сервера Kubernetes
    cluster_ca_certificate = base64decode(aws_eks_cluster.danit.certificate_authority.0.data) # Сертифікат авторизації кластера
    token                  = data.aws_eks_cluster_auth.danit.token                # Токен для автентифікації
  }
}

# Провайдер kubectl (закоментовано, може бути використаний для виконання команд)
# provider "kubectl" {
#   host                   = aws_eks_cluster.kubeedge.endpoint
#   cluster_ca_certificate = base64decode(aws_eks_cluster.kubeedge.certificate_authority.0.data)
#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     args        = ["--region", var.region, "eks", "get-token", "--cluster-name", var.name]
#     command     = "aws"
#   }
# }
