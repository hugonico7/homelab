resource "proxmox_virtual_environment_vm" "control-plane" {
  for_each = var.control-plane-config

  name      = each.value.name
  node_name = "promox"

  on_boot         = true
  stop_on_destroy = true

  agent {
    enabled = true
  }

  initialization {
    datastore_id = "local-lvm"
    ip_config {
      ipv4 {
        address = each.value.ipv4
        gateway = "192.168.0.1"
      }
    }
  }

  cpu {
    cores = each.value.cpu_cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = each.value.memory_dedicated * 1024
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "virtio0"
    iothread     = true
    import_from  = "local:import/nocloud-amd64.raw"
    size         = each.value.disk_size
  }

  network_device {
    bridge = "vmbr0"
  }

  operating_system {
    type = "l26"
  }
}
