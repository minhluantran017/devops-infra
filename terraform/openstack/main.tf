# Configure the OpenStack Provider
provider "openstack" {
  auth_url    = "${var.keystone_url}"
  user_name   = "${var.keystone_user}"
  tenant_name = "${var.keystone_tenant}"
  password    = "${var.keystone_password}"
  region      = "RegionOne"
  user_domain_name = "Default"
  project_domain_name = "Default"
}

# Create flavors
resource "openstack_compute_flavor_v2" "devops-medium-flavor" {
  name  = "devops-medium-flavor"
  ram   = "4096"
  vcpus = "2"
  disk  = "100"
}

resource "openstack_compute_flavor_v2" "devops-large-flavor" {
  name  = "devops-large-flavor"
  ram   = "8192"
  vcpus = "4"
  disk  = "100"
}

# Create image
resource "openstack_images_image_v2" "devops-image" {
  name             = "devops-centos7-generic-1907.qcow2"
  image_source_url = "https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1907.qcow2"
  container_format = "bare"
  disk_format      = "qcow2"
  tags             = ["devops","demo","centos"]
}

resource "openstack_orchestration_stack_v1" "devops-env" {
  name = "devops-env"
  parameters = {
    length = 4
  }
  template_opts = {
    File = "${path.module}/heat_template.yaml"
  }
  disable_rollback = true
  timeout = 30
}