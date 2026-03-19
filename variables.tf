variable "location" {
  description = "The Azure Region in which all resources should be created."
  type        = string
  default     = "East US"
}

variable "rg_name" {
  description = "The name of the resource group in which to create the virtual networks."
  type        = string
  default     = "rg-hub-spoke-arch"
}
