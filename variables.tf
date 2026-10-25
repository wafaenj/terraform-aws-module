variable "environment" {
  type        = string
  description = "Environnement de deploiement (dev ou prod)"

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "L'environnement doit obligatoirement etre 'dev' ou 'prod'."
  }
}

variable "name_prefix" {
  type        = string
  description = "Prefixe des ressources"
  default     = "novasphere"
}
