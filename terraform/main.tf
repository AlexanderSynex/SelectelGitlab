# Создание ключевой пары для доступа к ВМ
module "keypair" {
  source             = "./modules/keypair"
  keypair_name       = "keypair-tf"
  keypair_public_key = file("~/.ssh/id_ed25519.pub")
  region             = var.region
}

# Создание приватной сети для ВМ
module "nat" {
  source = "./modules/nat"
}

# Создание Gitlab сервера.
module "gitlab_server" {
  source = "./modules/server_gitlab"

  server_name             = "gitlab"
  server_zone             = var.server_zone
  server_vcpus            = var.gitlab_vcpus
  server_ram_mb           = var.gitlab_ram_mb
  server_root_disk_gb     = var.gitlab_root_disk_gb
  server_boot_volume_type = var.gitlab_boot_volume_type
  server_volume_type      = var.server_volume_type
  server_image_name       = var.gitlab_image_name
  server_ssh_key          = module.keypair.keypair_name
  region                  = var.region
  network_id              = module.nat.network_id
  subnet_id               = module.nat.subnet_id
  attached_disk_gb        = var.gitlab_attached_disk_gb
  public_ip               = var.gitlab_public_ip
  user_data               = file(var.gitlab_user_data_path)

  server_preemptible_tag = var.server_no_preemptible_tag
}


# Создание Gitlab-runner сервера.
module "gitlab_runner_server" {
  source = "./modules/server_gitlab_runner"

  server_name             = "runner"
  server_zone             = var.server_zone
  server_vcpus            = var.runner_vcpus
  server_ram_mb           = var.runner_ram_mb
  server_root_disk_gb     = var.runner_root_disk_gb
  server_boot_volume_type = var.server_volume_type
  server_image_name       = var.runner_image_name
  server_ssh_key          = module.keypair.keypair_name
  region                  = var.region
  network_name            = module.gitlab_server.network_name
  network_id              = module.gitlab_server.network_id
  subnet_id               = module.nat.subnet_id
  # user_data               = file(var.runner_user_data_path)

  server_preemptible_tag = var.server_no_preemptible_tag
}


# Создание inventory файла для ansible
# resource "local_file" "ansible_inventory" {
#   # content = templatefile("./resources/inventory.tmpl",
#   #   {
#   #     webapp_vm_ip_public  = module.preemptible_server.0.floating_ip,
#   #     database_vm_ip_public      = module.preemptible_server.1.floating_ip,
#   #     webapp_vm_ip_nat     = module.preemptible_server.1.nat_ip.0
#   #   }
#   # )
#   # filename = "../ansible/inventory.ini"
# }