locals {
  folder_name = "${var.folder}-${var.environment}-${random_integer.postfix.result}"
}

resource "random_integer" "postfix" {
  min = 40000
  max = 50000
}

data "yandex_resourcemanager_cloud" "cloud" {
  name = var.cloud
}

resource "yandex_resourcemanager_folder" "folder" {
  cloud_id    = data.yandex_resourcemanager_cloud.cloud.id
  name        = local.folder_name
  description = "Каталог для разворачивания инфраструктуры проекта"
  labels = {
    environment = var.environment
  }
}

provider "yandex" {
  alias = "with-project-info"

  cloud_id  = data.yandex_resourcemanager_cloud.cloud.id
  folder_id = yandex_resourcemanager_folder.folder.id
}

module "terraform-main" {
  source = "./main"

  providers = {
    yandex = yandex.with-project-info
  }

  folder-name = local.folder_name

  depends_on = [ yandex_resourcemanager_folder.folder ]
}
