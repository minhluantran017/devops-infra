variable "jenkins_master" {
    type = map
    default = {
        count     = "1"
        vcpu      = "4"
        memory    = "8096"
        disk      = "100000"
    }
}