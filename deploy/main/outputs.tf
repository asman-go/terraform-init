output "sa-terraform" {
  description = "Сервисный аккаунт для terraform remote backend"
  value       = yandex_iam_service_account.sa-terraform
}

# output "sa-terraform-static-key" {
#   description = "Статический ключ для сервисного аккаунта для работы с S3 & DynamoDB для terraform remote backend"
#   value       = yandex_iam_service_account_static_access_key.sa-terraform-static-key
#   sensitive = true
# }

output "storage-tfstate" {
  description = "S3 для хранения tfstate"
  value       = yandex_storage_bucket.asman-tfstate
  sensitive = true
}

output "document-api-endpoint" {
  description = "DynamoDB endpoint для сохранения истории блокировок"
  value       = yandex_ydb_database_serverless.asman-tfstate-lock.document_api_endpoint
}
