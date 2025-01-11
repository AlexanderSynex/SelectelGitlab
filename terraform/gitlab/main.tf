# Создание ключевой пары для доступа к ВМ
module "keypair" {
  source             = "../modules/keypair"
  keypair_name       = "ssh_key_ed"
  keypair_public_key = file("${var.ssh_key_file}.pub")
  region             = var.region
}

# Создание приватной сети для ВМ
module "nat" {
  source = "../modules/nat"
}

# Создание Gitlab сервера.
module "gitlab_server" {
  source = "../modules/server_gitlab"

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

# Создание inventory файла для ansible
resource "local_file" "ansible_inventory" {
  content = templatefile("../resources/inventory.tmpl",
    {
      gitlab_public_ip  = module.gitlab_server.floating_ip
      ssh_key_file      = var.ssh_key_file
    }
  )
  filename = "../../ansible/resources/inventory.ini"
}
