## Решение Домашнего задания "Управляющие конструкции в коде Terraform" - a148aa@yandex.ru

#### Задание 1

![alt text](image-1.png)

![alt text](image-2.png)

#### Задание 2

##### 2.1

```rb
resource "yandex_compute_instance" "web" {
  count = 2
  name = "web-${count.index+1}"
```


```
network_interface {
    ...
    security_group_ids = [yandex_vpc_security_group.example.id]
  }
```
##### 2.2

```rb
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
```

```rb
locals {
    vms_ssh_root_key = sensitive(file("~/.ssh/id_ed25519.pub"))
}
```

```rb
resource "yandex_compute_instance" "db" {
    for_each = {
        0 = var.each_vm.0
        1 = var.each_vm.1
    }
    name = "${each.value.vm_name}"
    ...

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.c_fract
    }

  boot_disk {
    initialize_params {
      ...
      size = each.value.disk_volume
    }
  }
  ...
```

![alt text](image-3.png)


#### Задание 3

##### 3.1-2

```rb
resource "yandex_compute_disk" "empty-disk" {
    count = 3
    name       = "${var.vm_disk.name_pref}-${count.index}"
    type       = var.vm_disk.type
    zone       = var.default_zone
    size       = var.vm_disk.size
    block_size = var.vm_disk.block_size
}
```

```rb
...
variable "vm_disk" {
  type = map(any)
  default = {
    "name_pref" = "disk",
    "type" = "network-hdd",
    "size" = 1,
    "block_size" = 4096
  }
}
```

#### Задание 4



```rb
locals {
  inventory = {
        webservers = yandex_compute_instance.web
        databases = yandex_compute_instance.db
        storage = yandex_compute_instance.storage
    }
}
resource "local_file" "ansible_inventory" {
    depends_on = [ yandex_compute_instance.storage, yandex_compute_instance.db, yandex_compute_instance.web ]
    filename = "./inventory.ini"
    content = templatefile("./ansible.tftpl", local.inventory) 
}
```

```

[webservers]


%{~ for i in  webservers ~}

${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]} fqdn=${i["fqdn"]}

%{~ endfor ~}






[databases]

%{~ for i in  databases ~}

${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]} fqdn=${i["fqdn"]}

%{~ endfor ~}



[storage]


${storage["name"]}   ansible_host=${storage["network_interface"][0]["nat_ip_address"]} fqdn=${storage["fqdn"]}
```
