#!/bin/bash -x

function install_terraform_kvm_plugin {
    PLUGIN_TAR=terraform-provider-libvirt-0.6.2+git.1585292411.8cbe9ad0.Ubuntu_18.04.amd64.tar.gz
    curl -LO https://github.com/dmacvicar/terraform-provider-libvirt/releases/download/v0.6.2/${PLUGIN_TAR}
    mkdir ${HOME}/.terraform.d/plugins/
    tar -xvzf ${PLUGIN_TAR} .terraform.d/plugins/
    apt install libvirt-clients genisoimage -y
}