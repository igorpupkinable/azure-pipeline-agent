source "azure-arm" "image" {
  # Authentication
  client_cert_password                   = var.client_cert_password
  client_cert_path                       = var.client_cert_path
  client_id                              = var.client_id
  subscription_id                        = var.subscription_id
  tenant_id                              = var.tenant_id

  # Common
  azure_tags                             = local.tags

  # Source
  shared_image_gallery {
    gallery_name                         = var.gallery_name
    image_name                           = var.gallery_image_name
    image_version                        = var.source_image_version
    resource_group                       = var.resource_group_name
    subscription                         = var.subscription_id
  }

  # Build
  build_resource_group_name              = var.build_resource_group_name
  os_disk_size_gb                        = var.os_disk_size_gb
  os_type                                = "Linux"
  private_virtual_network_with_public_ip = false
  secure_boot_enabled                    = true
  security_type                          = "TrustedLaunch"
  ssh_clear_authorized_keys              = true
  vm_size                                = "Standard_B2als_v2"
  vtpm_enabled                           = true

  # Artifact
  shared_gallery_image_version_end_of_life_date    = "2032-04-21T00:00:00.00Z"
  shared_gallery_image_version_exclude_from_latest = true

  shared_image_gallery_destination {
    gallery_name            = var.gallery_name
    image_name              = var.gallery_image_name
    image_version           = var.destination_image_version
    resource_group          = var.resource_group_name
    storage_account_type    = var.destination_image_storage
    subscription            = var.subscription_id
    use_shallow_replication = var.destination_image_shallow_replication
  }
}
