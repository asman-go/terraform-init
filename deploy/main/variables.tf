variable "folder-name" {
  description = "Название рабочего каталога"
  type        = string
}

variable "unique-postfix" {
  description = "Случайное число для создания уникальных имен (например, для сервисных аккаунтов)"
  type = number
}
