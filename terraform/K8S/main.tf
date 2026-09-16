terraform {
  required_version = "1.16.1"
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.6.2"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.3.0"
    }
  }
}

provider "kubectl" {
}
provider "http" {
}
provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }

}
