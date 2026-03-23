source "azure-arm" "image" {
  # Authentication
  client_cert_password                   = var.client_cert_password
  client_cert_path                       = var.client_cert_path
  client_id                              = var.client_id
  subscription_id                        = var.subscription_id
  tenant_id                              = var.tenant_id

  # Source
  # https://developer.hashicorp.com/packer/integrations/hashicorp/azure/latest/components/builder/arm#required:
  image_publisher                        = "Canonical"
  image_offer                            = split(":", var.source_image_sku)[0]
  image_sku                              = split(":", var.source_image_sku)[1]

  # Build
  build_resource_group_name              = var.build_resource_group_name
  image_version                          = var.source_image_version
  os_disk_size_gb                        = var.os_disk_size_gb
  os_type                                = "Linux"
  private_virtual_network_with_public_ip = false
  ssh_clear_authorized_keys              = true
  vm_size                                = "Standard_B2als_v2"

  # Artifact
  managed_image_name                     = var.managed_image_name
  managed_image_resource_group_name      = var.managed_image_resource_group_name

  shared_image_gallery_destination {
    gallery_name                         = var.gallery_name
    image_name                           = var.gallery_image_name
    image_version                        = var.gallery_image_version
    resource_group                       = var.gallery_resource_group_name
    storage_account_type                 = var.gallery_storage_account_type
    subscription                         = var.subscription_id
  }

  dynamic "azure_tag" {
    content {
      name  = azure_tag.key
      value = azure_tag.value
    }

    for_each = var.azure_tags
  }
}
