output "JENKINS_MASTER" {
  value = libvirt_domain.jenkins_master.*.network_interface.0.addresses
}

output "JENKINS_SLAVE" {
  value = libvirt_domain.jenkins_slave.*.network_interface.0.addresses
}
