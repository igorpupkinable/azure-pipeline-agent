build {
  sources = ["source.azure-arm.image"]
  name = "ubuntu-22_04"

  provisioner "shell" {
    execute_command = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    inline          = ["mkdir ${local.image_folder}", "chmod 777 ${local.image_folder}"]
  }

  provisioner "file" {
    destination = "${local.helper_script_folder}"
    source      = "${path.root}/../scripts/helpers"
  }

  provisioner "shell" {
    environment_vars = ["HELPER_SCRIPTS=${local.helper_script_folder}","DEBIAN_FRONTEND=noninteractive"]
    execute_command  = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    scripts          = [
      "${path.root}/../scripts/build/install-ms-repos.sh",
      "${path.root}/../scripts/build/configure-apt-sources.sh",
      "${path.root}/../scripts/build/configure-apt.sh",
      "${path.root}/../scripts/build/install-apt-packages.sh"
    ]
  }

  provisioner "file" {
    destination = "${local.installer_script_folder}"
    source      = "${path.root}/../scripts/build"
  }

  provisioner "file" {
    destination = "${local.image_folder}"
    sources     = [
      "${path.root}/../assets/post-gen"
    ]
  }

  provisioner "shell" {
    execute_command = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    inline          = [
      "mv ${local.image_folder}/post-gen ${local.image_folder}/post-generation"
    ]
  }

  provisioner "shell" {
    environment_vars = ["HELPER_SCRIPTS=${local.helper_script_folder}"]
    execute_command  = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    scripts          = ["${path.root}/../scripts/build/configure-environment.sh"]
  }

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "HELPER_SCRIPTS=${local.helper_script_folder}",
      "INSTALLER_SCRIPT_FOLDER=${local.installer_script_folder}"
    ]
    execute_command  = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    scripts          = [
      "${path.root}/../scripts/build/install-azure-cli.sh",
      "${path.root}/../scripts/build/install-git.sh",
      "${path.root}/../scripts/build/configure-dpkg.sh"
    ]
  }

  provisioner "shell" {
    environment_vars = [
      "HELPER_SCRIPTS=${local.helper_script_folder}",
      "INSTALLER_SCRIPT_FOLDER=${local.installer_script_folder}"
    ]
    execute_command  = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    script           = "${path.root}/../scripts/build/install-docker.sh"
  }

  # provisioner "shell" {
  #   environment_vars = [
  #     "DOCKERHUB_IMAGES='${var.dockerhub_images}'",
  #     "DOCKERHUB_LOGIN=${var.dockerhub_login}",
  #     "DOCKERHUB_PAT=${var.dockerhub_pat}",
  #     "INSTALLER_SCRIPT_FOLDER=${local.installer_script_folder}"
  #   ]
  #   execute_command  = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
  #   script           = "${path.root}/../scripts/build/configure-docker.sh"
  # }

  provisioner "shell" {
    environment_vars = ["HELPER_SCRIPTS=${local.helper_script_folder}"]
    execute_command  = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    scripts          = ["${path.root}/../scripts/build/configure-snap.sh"]
  }

  provisioner "shell" {
    execute_command = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    script          = "${path.root}/../scripts/build/list-dpkg.sh"
  }

  provisioner "file" {
    destination = var.installed_packages_filepath
    direction = "download"
    source = var.installed_packages_filepath
  }

  provisioner "shell" {
    execute_command   = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    expect_disconnect = true
    inline            = ["echo 'Reboot VM'", "sudo reboot"]
  }

  provisioner "shell" {
    execute_command     = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    pause_before        = "3m"
    scripts             = ["${path.root}/../scripts/build/cleanup.sh"]
    start_retry_timeout = "3m"
  }

  provisioner "shell" {
    environment_vars = [
      "HELPER_SCRIPT_FOLDER=${local.helper_script_folder}",
      "IMAGE_FOLDER=${local.image_folder}",
      "INSTALLER_SCRIPT_FOLDER=${local.installer_script_folder}"
    ]
    execute_command  = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    scripts          = ["${path.root}/../scripts/build/configure-system.sh"]
  }

  provisioner "shell" {
    environment_vars = ["HELPER_SCRIPTS=${local.helper_script_folder}"]
    execute_command  = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    scripts          = ["${path.root}/../scripts/build/post-build-validation.sh"]
  }

  provisioner "shell" {
    execute_command = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    inline          = ["sleep 30", "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
  }

}
