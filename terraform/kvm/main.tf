#################################
#  PREPARE THE DEPLOYMENT
#################################

resource "libvirt_pool" "devops" {
  name          = "devops"
  type          = "dir"
  path          = "/tmp/devops"
}
resource "libvirt_volume" "os_image" {
  name          = "bionic-server-cloudimg-amd64.img"
  source        = "https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img"
#  source        = "file:///root/bionic-server-cloudimg-amd64.img"
  pool          = libvirt_pool.devops.name
}

module "jenkins-master" {
    source  = "./module"
    vm_name    = "jenkins_master"
    vm_count     = 1
    vm_vcpu      = 4
    vm_memory    = 8096
    vm_disk      = 100000000000
    addresses = [
        "10.250.200.191"
    ]
    base_image_id   = libvirt_volume.os_image.id
}