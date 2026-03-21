locals {
  image_properties_map = {
      "ubuntu22" = {
            source_image_marketplace_sku = "canonical:0001-com-ubuntu-server-jammy:22_04-lts-gen2"
      },
      "ubuntu24" = {
            source_image_marketplace_sku = "canonical:ubuntu-24_04-lts:server"
      },
      "ubuntuMinimal22" = {
            source_image_marketplace_sku = "Canonical:0001-com-ubuntu-minimal-jammy:minimal-22_04-lts-gen2"
      }
  }

  source_image_marketplace_sku = local.image_properties_map[var.image_os].source_image_marketplace_sku
}
