source "azure-arm" "image" {
  # Authentication parameters
  client_cert_password                   = var.client_cert_password
  client_cert_path                       = var.client_cert_path
  client_cert_token_timeout              = "1h" # Microsoft-hosted Free tier agents are limited to 60 minutes per run
  client_id                              = var.client_id
  object_id                              = var.object_id
  subscription_id                        = var.subscription_id
  tenant_id                              = var.tenant_id

  # Required parameters
  image_publisher                        = split(":", local.source_image_marketplace_sku)[0]
  image_offer                            = split(":", local.source_image_marketplace_sku)[1]
  image_sku                              = split(":", local.source_image_marketplace_sku)[2]

  allowed_inbound_ip_addresses           = var.allowed_inbound_ip_addresses
  build_resource_group_name              = var.build_resource_group_name
  image_version                          = var.source_image_version
  managed_image_name                     = var.managed_image_name
  managed_image_resource_group_name      = var.managed_image_resource_group_name
  os_disk_size_gb                        = var.os_disk_size_gb
  os_type                                = var.image_os_type
  private_virtual_network_with_public_ip = var.private_virtual_network_with_public_ip
  ssh_clear_authorized_keys              = var.ssh_clear_authorized_keys
  virtual_network_name                   = var.virtual_network_name
  virtual_network_resource_group_name    = var.virtual_network_resource_group_name
  virtual_network_subnet_name            = var.virtual_network_subnet_name
  vm_size                                = var.vm_size
  winrm_username                         = var.winrm_username

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
