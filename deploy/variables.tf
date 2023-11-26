variable "environment" {
  description = "Окружение: testing или production"
  type        = string
  default     = "testing"
}

variable "cloud" {
  description = "Название облака"
  type        = string
  default     = "ikemurami-cloud"
}

variable "folder" {
  description = "Название рабочего каталога (итоговое будет соединено с environment)"
  type        = string
  default     = "asman"
}

variable "region" {
  description = "Регион, в котором наше облако развернуто"
  type        = string
}

variable "zone" {
  description = "Зона, в которой наше облако развернуто"
  type        = string
}
