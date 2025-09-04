
variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
  default     = "MyWebAppProject-RG"
}

variable "location" {
  description = "The Azure region where resources will be created."
  type        = string
  default     = "East US"
}

variable "db_admin_login" {
  description = "The administrator login for the PostgreSQL server."
  type        = string
  default     = "psqladmin"
}

variable "db_password" {
  description = "The administrator password for the PostgreSQL server."
  type        = string
  sensitive   = true # Marks this as a secret
}
