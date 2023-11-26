data "yandex_resourcemanager_folder" "asman-folder" {
  name = var.folder-name
}

// Создаем service account
resource "yandex_iam_service_account" "sa-terraform" {
  name        = "sa-terraform-remote-${var.unique-postfix}"
  description = "Сервисный аккаунт для доступа к YDB/S3 для управления хранилищем состояния инфраструктуры tfstate"
}

// Выдаем права на католог
resource "yandex_resourcemanager_folder_iam_binding" "sa-terraform-ydb-editor" {
  folder_id = data.yandex_resourcemanager_folder.asman-folder.id

  role    = "ydb.editor"
  members = ["serviceAccount:${yandex_iam_service_account.sa-terraform.id}"]
}

resource "yandex_resourcemanager_folder_iam_binding" "sa-terraform-storage-editor" {
  folder_id = data.yandex_resourcemanager_folder.asman-folder.id

  role    = "storage.editor"
  members = ["serviceAccount:${yandex_iam_service_account.sa-terraform.id}"]
}

// Создаем ключи для создания бакетов и доступа к YDB по протоколу DynamoDB
resource "yandex_iam_service_account_static_access_key" "sa-terraform-static-key" {
  service_account_id = yandex_iam_service_account.sa-terraform.id
  description        = "Static access key for S3 and DynamoDB"
}

// Создаем ресурсы
resource "yandex_storage_bucket" "asman-tfstate" {
  bucket = "asman-tfstate-${var.unique-postfix}"

  access_key = yandex_iam_service_account_static_access_key.sa-terraform-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-terraform-static-key.secret_key

  acl                   = "private"
  max_size              = 10 * 1024 * 1024 // 10MB
  default_storage_class = "STANDARD"       // Default
}

resource "yandex_ydb_database_serverless" "asman-tfstate-lock" {
  name        = "asman-tfstate-lock"
  description = "База данных для фиксации блокировки состояния"
}
