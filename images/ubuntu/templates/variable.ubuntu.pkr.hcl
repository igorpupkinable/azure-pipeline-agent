# Authentication
variable "client_cert_password" {
  sensitive = true
  type    = string
}
variable "client_cert_path" {
  type    = string
}
variable "client_id" {
  sensitive = true
  type    = string
}
variable "subscription_id" {
  type    = string
}
variable "tenant_id" {
  type    = string
}

# Source and destination
variable "gallery_name" {
  type    = string
}
variable "gallery_image_name" {
  type    = string
}
variable "resource_group_name" {
  type    = string
}

# Source image
variable "source_image_sku" {
  type    = string
}
variable "source_image_version" {
  default = "latest"
  type    = string
}

# Build stage VM
variable "dockerhub_images" {
  type    = string
}
variable "dockerhub_login" {
  sensitive = true
  type    = string
}
variable "dockerhub_pat" {
  sensitive = true
  type    = string
}

# Destination image
variable "azure_tags" {
  default = {}
  type    = map(string)
}
variable "build_resource_group_name" {
  type    = string
}
variable "destination_image_storage" {
  default = "Standard_LRS"
  type    = string
}
variable "destination_image_version" {
  type    = string
}
variable "os_disk_size_gb" {
  default = 30
  type    = number
}
