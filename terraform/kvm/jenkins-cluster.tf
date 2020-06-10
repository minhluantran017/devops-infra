## Jenkins master
data "template_file" "jenkins_master" {
  count = lookup(var.jenkins_master, "count")
  template      = file("${path.module}/network_config.cfg")
  vars = {
    IPADDR = element(var.jenkins_master_addresses, count.index)
  }
}

resource "libvirt_cloudinit_disk" "jenkins_master" {
  count         = lookup(var.jenkins_master, "count")
  name          = "commoninit_jenkins_master_${count.index}.iso"
  user_data     = data.template_file.user_data.rendered
  network_config= data.template_file.jenkins_master[count.index].rendered
  pool          = libvirt_pool.devops.name
}

resource "libvirt_volume" "jenkins_master" {
  count         = lookup(var.jenkins_master, "count")
  name          = "jenkins_master_${count.index}"
  pool          = libvirt_pool.devops.name
  size          = lookup(var.jenkins_master, "disk")
  base_volume_id= libvirt_volume.os_image.id
}

resource "libvirt_domain" "jenkins_master" {
  count         = lookup(var.jenkins_master, "count")
  name          = "jenkins_master_${count.index}"
  memory        = lookup(var.jenkins_master, "memory")
  vcpu          = lookup(var.jenkins_master, "vcpu")
  qemu_agent    = true
  autostart     = false
  cloudinit     = element(libvirt_cloudinit_disk.jenkins_slave.*.id, count.index)
  network_interface {
    hostname    = "jenkins_master_${count.index}"
    macvtap     = "enp4s0f0"
    addresses   = [element(var.jenkins_master_addresses, count.index)]
    wait_for_lease = true

  }
  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  disk {
    volume_id   = element(libvirt_volume.jenkins_master.*.id, count.index)
  }
  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

## Jenkins slaves
data "template_file" "jenkins_slave" {
  count = lookup(var.jenkins_slave, "count")
  template      = file("${path.module}/network_config.cfg")
  vars = {
    IPADDR = element(var.jenkins_slave_addresses, count.index)
  }
}

resource "libvirt_cloudinit_disk" "jenkins_slave" {
  count         = lookup(var.jenkins_slave, "count")
  name          = "commoninit_jenkins_slave_${count.index}.iso"
  user_data     = data.template_file.user_data.rendered
  network_config= data.template_file.jenkins_slave[count.index].rendered
  pool          = libvirt_pool.devops.name
}

resource "libvirt_volume" "jenkins_slave" {
  count         = lookup(var.jenkins_slave, "count")
  name          = "jenkins_slave_${count.index}"
  pool          = libvirt_pool.devops.name
  size          = lookup(var.jenkins_slave, "disk")
  base_volume_id= libvirt_volume.os_image.id
}

resource "libvirt_domain" "jenkins_slave" {
  count         = lookup(var.jenkins_slave, "count")
  name          = "jenkins_slave_${count.index}"
  memory        = lookup(var.jenkins_slave, "memory")
  vcpu          = lookup(var.jenkins_slave, "vcpu")
  qemu_agent    = true
  autostart     = true
  cloudinit     = element(libvirt_cloudinit_disk.jenkins_slave.*.id, count.index)
  network_interface {
    hostname    = "jenkins_slave_${count.index}"
    macvtap     = "enp4s0f0"
    addresses   = [element(var.jenkins_slave_addresses, count.index)]
    wait_for_lease = true

  }
  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  disk {
    volume_id   = element(libvirt_volume.jenkins_slave.*.id, count.index)
  }
  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}