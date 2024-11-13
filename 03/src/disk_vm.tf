# Создайте 3 одинаковых виртуальных диска размером 1 Гб с помощью ресурса yandex_compute_disk и мета-аргумента count в файле disk_vm.tf .

resource "yandex_compute_disk" "empty-disk" {
    count = 3
    name       = "${var.vm_disk.name_pref}-${count.index}"
    type       = var.vm_disk.type
    zone       = var.default_zone
    size       = var.vm_disk.size
    block_size = var.vm_disk.block_size
}

resource "yandex_compute_instance" "storage" {
  name = var.storage_vm.vm_name
  folder_id = var.folder_id
  platform_id = var.platform.3

  resources {
    cores         = var.storage_vm.cpu
    memory        = var.storage_vm.ram
    core_fraction = var.storage_vm.c_fract
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.os_image.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    # security_group_ids = [yandex_vpc_security_group.example.id]
  }

    metadata = {
    serial-port-enable = local.vms_ssh_root_key
    ssh-keys           = var.vms_ssh_port
  }

  dynamic secondary_disk {
    for_each = {
        0 = yandex_compute_disk.empty-disk[0],
        1 = yandex_compute_disk.empty-disk[1],
        2 = yandex_compute_disk.empty-disk[2]
    }
    content {
        disk_id = secondary_disk.value.id 
    }
  }
}