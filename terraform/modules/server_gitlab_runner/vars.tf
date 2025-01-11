variable "server_vcpus" {
  default = 2
}

variable "server_ram_mb" {
  default = 4096
}

variable "server_root_disk_gb" {
  default = 20
}

variable "server_boot_volume_type" {
  default = "universal.ru-3a"
}

variable "server_name" {
  default = "server_runner_1"
}

variable "server_image_name" {}

variable "server_zone" {
  default = "ru-3a"
}

variable "server_ssh_key" {}

variable "region" {}

variable "server_license_type" {
  default = ""
}
variable "server_group_id" {
  default = ""
}

variable "server_preemptible_tag" {
  default = []
}

variable "network_name" {
  default = "network-eth0"
}

variable "network_id" {}
variable "subnet_id" {}
variable "user_data" {}
