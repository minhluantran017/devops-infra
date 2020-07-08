data "template_file" "user_data" {
  template      = file("${path.module}/cloud_init.cfg")
}

data "template_file" "virtual_machine" {
  count = var.vm_count
  template      = file("${path.module}/network_config.cfg")
  vars = {
    IPADDR = element(var.addresses, count.index)
  }
}

resource "libvirt_cloudinit_disk" "virtual_machine" {
  count         = var.vm_count
  name          = "${var.vm_name}_${count.index}.iso"
  user_data     = data.template_file.user_data.rendered
  network_config= data.template_file.virtual_machine[count.index].rendered
  pool          = "devops"
}

resource "libvirt_volume" "virtual_machine" {
  count         = var.vm_count
  name          = "${var.vm_name}_${count.index}"
  pool          = "devops"
  size          = var.vm_disk
  base_volume_id= var.base_image_id
}

resource "libvirt_domain" "virtual_machine" {
  count         = var.vm_count
  name          = "${var.vm_name}_${count.index}"
  memory        = var.vm_memory
  vcpu          = var.vm_vcpu
  qemu_agent    = true
  autostart     = false
  cloudinit     = element(libvirt_cloudinit_disk.virtual_machine.*.id, count.index)
  network_interface {
    hostname    = "${var.vm_name}_${count.index}"
    macvtap     = "enp4s0f0"
    addresses   = [element(var.addresses, count.index)]
    wait_for_lease = true
  }
  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }
  disk {
    volume_id   = element(libvirt_volume.virtual_machine.*.id, count.index)
  }
  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}
