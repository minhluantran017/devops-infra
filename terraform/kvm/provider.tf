provider "libvirt" {
  uri = "qemu+ssh://root@10.250.200.250/system"
}

terraform {
  required_version = ">= 0.12"
}
