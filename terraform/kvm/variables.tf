variable "jenkins_master" {
    type = map
    default = {
        count     = "1"
        vcpu      = "4"
        memory    = "8096"
        disk      = "100000000000"
    }
}
variable "jenkins_master_addresses" {
    type = list
    default = [
        "10.250.200.111"
    ]
}

variable "jenkins_slave" {
    type = map
    default = {
        count     = "1"
        vcpu      = "4"
        memory    = "8096"
        disk      = "100000000000"
    }
}

variable "jenkins_slave_addresses" {
    type = list
    default = [
        "10.250.200.112"
    ]
}