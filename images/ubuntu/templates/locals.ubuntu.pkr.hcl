locals {
  helper_script_folder = "/imagegeneration/helpers"
  image_folder = "/imagegeneration"
  installer_script_folder = "/imagegeneration/installers"
  tags = merge(
    var.tags_default,
    var.build_number == null ? var.tags_build_number_empty : { BuildNumber = var.build_number },
    var.dockerhub_images != null && length(var.dockerhub_images) > 0 ? { DockerImages = replace(var.dockerhub_images, " ", ";") } : var.tags_docker_images_empty,
  )
}