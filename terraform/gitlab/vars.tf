# General 

variable "ssh_key_file" {
  default = "~/.ssh/id_rsa"
  type = string
}

variable "keypair_name" {
  default = "tf_keypair"
}

variable "os_auth_url" {
  default = "https://api.selvpc.ru/identity/v3"
}

variable "region" {
  default = "ru-7"
}

variable "server_volume_type" {
  default = "universal.ru-7a"
}

variable "server_preemptible_tag" {
  default = ["preemptible"]
}

variable "server_no_preemptible_tag" {
  default = []
}

# Gitlab

variable "gitlab_vcpus" {
  default = 8
}

variable "gitlab_ram_mb" {
  default = 12288
}

variable "gitlab_root_disk_gb" {
  default = 64
}

variable "gitlab_boot_volume_type" {
  default = "fast.ru-7a"
}

variable "gitlab_image_name" {
  default = "Cloud Gitlab 16.11.10 64-bit"
}

variable "gitlab_user_data_path" {
  type = string
  default = "gitlab_metadata.cfg"
}

variable "gitlab_attached_disk_gb" {
  default = 128
  type = number
}

### ATTENTION!!! Do not edit this block, please.
variable "server_zone" {
  type        = string
  description = "The name of the Selectel's pool."

  default = "ru-7a"

  validation {
    condition     = can(regex("ru-7a", var.server_zone))
    error_message = "Preemtible servers are available in ru-7a pool only."
  }
}

# Sensitive block
variable "domain_name" {
  sensitive = true
}

variable "tenant_id" {
  sensitive = true
}

variable "user_name" {
  sensitive = true
}

variable "password" {
  sensitive = true
}

variable "gitlab_public_ip" {
  sensitive = true
}
