// Authentication related variables
variable "client_cert_password" {
  default = "${env("ARM_CLIENT_CERT_PASSWORD")}"
  sensitive = true
  type    = string
}
variable "client_cert_path" {
  default = "${env("ARM_CLIENT_CERT_PATH")}"
  type    = string
}
variable "client_id" {
  default = "${env("ARM_CLIENT_ID")}"
  sensitive = true
  type    = string
}
variable "subscription_id" {
  default = "${env("ARM_SUBSCRIPTION_ID")}"
  type    = string
}
variable "tenant_id" {
  default = "${env("ARM_TENANT_ID")}"
  type    = string
}

// Azure environment related variables
variable "allowed_inbound_ip_addresses" {
  type    = list(string)
  default = []
}
variable "azure_tags" {
  type    = map(string)
  default = {}
}
variable "build_resource_group_name" {
  type    = string
  default = "${env("BUILD_RG_NAME")}"
}
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
variable "image_os_type" {
  type    = string
  default = "Linux"
}
variable "managed_image_name" {
  type    = string
  default = ""
}
variable "managed_image_resource_group_name" {
  type    = string
  default = "${env("ARM_RESOURCE_GROUP")}"
}
variable "private_virtual_network_with_public_ip" {
  type    = bool
  default = false
}
variable "os_disk_size_gb" {
  type    = number
  default = 30
}
variable "source_image_version" {
  type    = string
  default = "latest"
}
variable "virtual_network_name" {
  type    = string
  default = "${env("VNET_NAME")}"
}
variable "virtual_network_resource_group_name" {
  type    = string
  default = "${env("VNET_RESOURCE_GROUP")}"
}
variable "virtual_network_subnet_name" {
  type    = string
  default = "${env("VNET_SUBNET")}"
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
variable "vm_size" {
  type    = string
  default = "Standard_D4s_v4"
}
variable "winrm_username" {         // The username used to connect to the VM via WinRM
    type    = string                // Also applies to the username used to create the VM
    default = "packer"
}

// Image related variables
variable "helper_script_folder" {
  type    = string
  default = "/imagegeneration/helpers"
}
variable "image_folder" {
  type    = string
  default = "/imagegeneration"
}
variable "source_image_sku" {
  type    = string
  default = "Canonical:0001-com-ubuntu-minimal-jammy:minimal-22_04-lts-gen2"
}
variable "image_version" {
  type    = string
  default = "dev"
}
variable "imagedata_file" {
  type    = string
  default = "/imagegeneration/imagedata.json"
}
variable "installer_script_folder" {
  type    = string
  default = "/imagegeneration/installers"
}
variable "install_password" {
  type      = string
  default   = ""
  sensitive = true
}
variable "install_user" {
  type    = string
  default = "installer"
}
