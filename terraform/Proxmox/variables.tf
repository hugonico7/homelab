variable "proxmox_username" {
  type        = string
  description = "Proxmox Username Value"
}

variable "proxmox_password" {
  type        = string
  sensitive   = true
  description = "Proxmox Password Value"
}
