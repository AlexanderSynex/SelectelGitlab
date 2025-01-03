variable "server_vcpus" {
  default = 4
}

variable "server_ram_mb" {
  default = 8192
}

variable "server_root_disk_gb" {
  default = 8
}

variable "server_volume_type" {
  default = "fast.ru-3a"
}

variable "server_name" {
  default = "server_1"
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

variable "network_id" {}

variable "subnet_id" {}

variable "user_data_path" {
  type = string
  default = ""
}

variable "attached_disk_gb" {
  default = 20
  type = number
}

variable "public_ip" {
  sensitive = true
}