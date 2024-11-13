###cloud vars
variable "token" {
  type        = string
  sensitive = true
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}


variable "cloud_id" {
  type        = string
  sensitive = true
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  sensitive = true
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "platform" {
  type = map(string)
  default = {
    1 = "standard-v1"
    2 = "standard-v2"
    3 = "standard-v3"
  }
}
variable vm_param {
  type = map(any)
  default = {
    web = ({
      cores = 2,
      memory = 1,
      core_fract = 20
    })
  }
}

variable "image" {
  type = map(string)
  default = {
    web="ubuntu-2204-lts"
    }
}

/* variable "vms_ssh_root_key" {
  type        = string
  # default     = ""
  description = "ssh-keygen -t ed25519"
} */

variable "vms_ssh_port" {
  type = string
  sensitive = true
  default = "22"
}

variable "web_name" {
  type = set(string)
  default = [ "1", "2" ]
}

variable "each_vm" {
  type = list(object({  
    vm_name=string,
    cpu=number,
    ram=number,
    disk_volume=number,
    c_fract=number
    }))
  default = [ {
      vm_name = "main",
      cpu = 4,
      ram = 4,
      disk_volume = 10,
      c_fract = 20
    },
    {
      cpu = 2
      disk_volume = 16
      ram = 2
      vm_name = "replica",
      c_fract = 20
    } ]
}

variable "vm_disk" {
  type = map(string)
  default = {
    "name_pref" = "disk",
    "type" = "network-hdd",
    "size" = "1G",
    "block_size" = "4"
  }
}