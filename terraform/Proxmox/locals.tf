
locals {

  ## Control Plane nodes
  control-plane-config = {
    cp-01-jupiter = {
      name             = "cp-01-jupiter"
      ipv4             = "192.168.0.200/24"
      cpu_cores        = 4
      memory_dedicated = 8
      disk_size        = 40
    }
    cp-02-saturno = {
      name             = "cp-02-saturno"
      ipv4             = "192.168.0.201/24"
      cpu_cores        = 4
      memory_dedicated = 8
      disk_size        = 40
    }
  }

  ## Worker nodes
  worker-config = {

    wor-01-pegasus = {
      name             = "wor-01-pegasus"
      ipv4             = "192.168.0.211/24"
      cpu_cores        = 6
      memory_dedicated = 20
      disk_size        = 60
    }

    wor-02-perseo = {
      name             = "wor-02-perseo"
      ipv4             = "192.168.0.212/24"
      cpu_cores        = 6
      memory_dedicated = 16
      disk_size        = 60
    }

    wor-03-casiopea = {
      name             = "wor-03-casiopea"
      ipv4             = "192.168.0.213/24"
      cpu_cores        = 6
      memory_dedicated = 16
      disk_size        = 60
    }

    wor-04-leon = {
      name             = "wor-04-leon"
      ipv4             = "192.168.0.214/24"
      cpu_cores        = 6
      memory_dedicated = 16
      disk_size        = 60
    }
  }
}
