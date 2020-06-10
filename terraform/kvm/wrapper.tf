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
#  source        = "/root/CentOS-7-x86_64-GenericCloud-1907.qcow2"
  pool          = libvirt_pool.devops.name
}

data "template_file" "user_data" {
  template      = file("${path.module}/cloud_init.cfg")
}


