variable "vm_name" {
    type = string
}

variable "vm_count" {
    type = number
}

variable "vm_vcpu" {
    type = number
}

variable "vm_memory" {
    type = number
}

variable "vm_disk" {
    type = number
}

variable "addresses" {
    type = list(string)
}

variable "base_image_id" {}