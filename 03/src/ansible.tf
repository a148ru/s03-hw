
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
