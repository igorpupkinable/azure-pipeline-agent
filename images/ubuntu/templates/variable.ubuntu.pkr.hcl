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

# Source image
variable "source_image_sku" {
  type    = string
}
variable "source_image_version" {
  type    = string
  default = "latest"
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
variable "managed_image_name" {
  type    = string
}
variable "managed_image_resource_group_name" {
  type    = string
}
variable "os_disk_size_gb" {
  type    = number
  default = 30
}

// Azure environment related variables
variable "gallery_image_name" {
  type    = string
  default = "${env("GALLERY_IMAGE_NAME")}"
}
variable "gallery_image_version" {
  type    = string
  default = "${env("GALLERY_IMAGE_VERSION")}"
}
variable "gallery_name" {
  type    = string
  default = "${env("GALLERY_NAME")}"
}
variable "gallery_resource_group_name" {
  type    = string
  default = "${env("GALLERY_RG_NAME")}"
}
variable "gallery_storage_account_type" {
  type    = string
  default = "${env("GALLERY_STORAGE_ACCOUNT_TYPE")}"
}
