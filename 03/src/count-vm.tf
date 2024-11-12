data "yandex_compute_image" "os_image" {
  family = var.image.web
}

resource "yandex_compute_instance" "web" {
  depends_on = [ yandex_compute_instance.db ]
  count = 2
  name = "web-${count.index+1}"
  folder_id = var.folder_id
  platform_id = var.platform.3

  resources {
    cores         = var.vm_param.web.cores
    memory        = var.vm_param.web.memory
    core_fraction = var.vm_param.web.core_fract
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
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

    metadata = {
    serial-port-enable = local.vms_ssh_root_key
    ssh-keys           = var.vms_ssh_port
  }
}