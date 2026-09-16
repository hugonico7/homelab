variable "control-plane-config" {
  type = map(object({
    name             = string
    ipv4             = string
    cpu_cores        = number
    disk_size        = number
    memory_dedicated = number
  }))
}

variable "worker-config" {
  type = map(object({
    name             = string
    ipv4             = string
    cpu_cores        = number
    disk_size        = number
    memory_dedicated = number
  }))
}
