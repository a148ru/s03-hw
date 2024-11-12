
resource "yandex_compute_instance" "db" {
    for_each = {
        0 = var.each_vm.0
        1 = var.each_vm.1
    }
    name = "${each.value.vm_name}"
    folder_id = var.folder_id
    platform_id = var.platform.3

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.c_fract
    }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.os_image.image_id
      size = each.value.disk_volume
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

    metadata = {
    serial-port-enable = local.vms_ssh_root_key
    ssh-keys           = var.vms_ssh_port
  }
}