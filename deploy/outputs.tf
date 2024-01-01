output "sa-terraform" {
  description = "Сервисный аккаунт для terraform remote backend"
  value       = module.terraform-main.sa-terraform
}

output "folder" {
  description = "Каталог под проект"
  value       = local.folder_name
}

# output "sa-terraform-static-key" {
#   description = "Статический ключ для сервисного аккаунта для работы с S3 & DynamoDB для terraform remote backend"
#   value       = module.terraform-main.sa-terraform-static-key
#   sensitive   = true
# }

output "storage-tfstate" {
  description = "S3 для хранения tfstate"
  value       = module.terraform-main.storage-tfstate
  sensitive = true
}

output "document-api-endpoint" {
  description = "DynamoDB endpoint для сохранения истории блокировок"
  value       = module.terraform-main.document-api-endpoint
}
