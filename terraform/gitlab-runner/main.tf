# Создание ключевой пары для доступа к ВМ
module "keypair" {
  source             = "../modules/keypair"
  keypair_name       = "ssh_runner_key_ed"
  keypair_public_key = file("${var.ssh_key_file}.pub")
  region             = var.region
}

# Создание приватной сети для ВМ
module "nat" {
  source = "../modules/nat"
}

# Создание Gitlab-runner сервера.
module "gitlab_runner_server" {
  source = "../modules/server_gitlab_runner"

  server_name             = "runner"
  server_zone             = var.server_zone
  server_vcpus            = var.runner_vcpus
  server_ram_mb           = var.runner_ram_mb
  server_root_disk_gb     = var.runner_root_disk_gb
  server_boot_volume_type = var.server_volume_type
  server_image_name       = var.runner_image_name
  server_ssh_key          = module.keypair.keypair_name
  region                  = var.region
  network_id              = module.nat.network_id
  subnet_id               = module.nat.subnet_id
  user_data               = file(var.runner_user_data_path)

  server_preemptible_tag = var.server_no_preemptible_tag
}
