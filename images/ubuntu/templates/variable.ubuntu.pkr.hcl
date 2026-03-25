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
variable "source_image_version" {
  default = "latest"
  type    = string
}

# Build stage VM
variable "build_number" {
  default = null
  type    = string
}
variable "dockerhub_images" {
  default = null
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
variable "tags_build_number_empty" {
  default = {
    BuildNumber = "00000000.0"
  }
  type    = map(string)
}
variable "tags_docker_images_empty" {
  default = {
    DockerImages = "none"
  }
  type    = map(string)
}

# Destination image
variable "build_resource_group_name" {
  type    = string
}
variable "destination_image_shallow_replication" {
  default = true
  type    = bool
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
variable "tags_default" {
  default = {
    CreatedBy   = "Azure Pipeline"
    Environment = "DevOps"
    State       = "Configured"
    Type        = "Pipeline Agent"
  }
  type    = map(string)
}
