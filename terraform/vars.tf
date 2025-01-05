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
  default = 1
}

variable "gitlab_ram_mb" {
  default = 8192
}

variable "gitlab_root_disk_gb" {
  default = 30
}

variable "gitlab_boot_volume_type" {
  default = "fast.ru-7a"
}

variable "gitlab_image_name" {
  default = "Cloud Gitlab 16.11.10 64-bit"
}

variable "gitlab_user_data_path" {
  type = string
  default = ""
}

variable "gitlab_attached_disk_gb" {
  default = 20
  type = number
}

# Gitlab runner

variable "runner_vcpus" {
  default = 2
}

variable "runner_ram_mb" {
  default = 4096
}

variable "runner_root_disk_gb" {
  default = 20
}

variable "runner_image_name" {
  default = "Cloud Gitlab Runner 17.0.0 64-bit"
}

variable "runner_user_data_path" {
  type = string
  default = ""
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
