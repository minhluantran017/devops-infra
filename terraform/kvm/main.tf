provider "libvirt" {
  uri = "qemu+ssh://root@10.250.200.220/system?socket=/var/run/libvirt/libvirt-sock"
}

#################################
#  PREPARE THE DEPLOYMENT
#################################

resource "libvirt_pool" "devops" {
  name          = "devops"
  type          = "dir"
  path          = "/tmp/devops"
}
resource "libvirt_volume" "os_image" {
  name          = "CentOS-7-x86_64-GenericCloud-1907.qcow2"
  source        = "https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1907.qcow2"
  pool          = libvirt_pool.devops.name
}

data "template_file" "user_data" {
  template      = file("${path.module}/../../common/cloud_init.cfg")
}

data "template_file" "network_config" {
  template      = file("${path.module}/network_config.cfg")
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name          = "commoninit.iso"
  user_data     = data.template_file.user_data.rendered
  network_config= data.template_file.network_config.rendered
  pool          = libvirt_pool.devops.name
}

#################################
# CREATE THE MACHINES AND VOLUMES
#################################

## Jenkins master
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
  cloudinit     = libvirt_cloudinit_disk.commoninit.id
  network_interface {
    hostname    = "jenkins_master_${count.index}"
  }
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }
  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }
  disk {
    volume_id   = element(libvirt_volume.jenkins_master.*.id, count.index)
  }
  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
  xml {
    xslt =<<EOF
<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output omit-xml-declaration="yes" indent="yes"/>
    <xsl:template match="node()|@*">
        <xsl:copy>
        <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[text() = '/dev/urandom']/text()">
        <xsl:value-of select="'/dev/random'"/>
    </xsl:template>

</xsl:stylesheet>
EOF
  }
}


terraform {
  required_version = ">= 0.12"
}
output "terraform-test-ip" {
  value = libvirt_domain.jenkins_master.*.network_interface.0.addresses
}