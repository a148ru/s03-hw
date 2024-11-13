# Создайте 3 одинаковых виртуальных диска размером 1 Гб с помощью ресурса yandex_compute_disk и мета-аргумента count в файле disk_vm.tf .

resource "yandex_compute_disk" "empty-disk" {
    count = 3
    name       = "${var.vm_disk.name_pref}-${count.index}"
    type       = var.vm_disk.type
    zone       = var.default_zone
    size       = var.vm_disk.size
    block_size = var.vm_disk.block_size
}