terraform {
  required_version = "1.16.1"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.113.1"
    }
  }
}

provider "proxmox" {
  endpoint = "https://192.168.0.160:8006/"

  username = var.proxmox_username
  password = var.proxmox_password

  insecure = true
}
