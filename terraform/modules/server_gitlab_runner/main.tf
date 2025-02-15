resource "random_string" "random_name" {
  length  = 5
  special = false
}

module "flavor" {
  source        = "../flavor"
  flavor_name   = "flavor-${random_string.random_name.result}"
  flavor_vcpus  = var.server_vcpus
  flavor_ram_mb = var.server_ram_mb
}


resource "openstack_networking_port_v2" "port_1" {
  name       = "${var.server_name}-eth0"
  network_id = var.network_id

  fixed_ip {
    subnet_id = var.subnet_id
  }
}

# Источник образов
module "image_datasource" {
  source     = "../image_datasource"
  image_name = var.server_image_name
}

# Загрузочный диск
resource "openstack_blockstorage_volume_v3" "boot_volume" {
  name              = "${var.server_name}-boot-volume"
  size              = var.server_root_disk_gb
  image_id          = module.image_datasource.image_id
  volume_type       = var.server_boot_volume_type
  availability_zone = var.server_zone

  lifecycle {
    ignore_changes = [image_id]
  }
}

resource "openstack_compute_instance_v2" "instance_1" {
  name              = var.server_name
  flavor_id         = module.flavor.flavor_id
  key_pair          = var.server_ssh_key
  availability_zone = var.server_zone

  network {
    port = openstack_networking_port_v2.port_1.id
  }

  dynamic "network" {
    for_each = var.server_license_type != "" ? [var.server_license_type] : []

    content {
      name = var.server_license_type
    }
  }


  block_device {
    uuid             = openstack_blockstorage_volume_v3.boot_volume.id
    source_type      = "volume"
    destination_type = "volume"
    boot_index       = 0
  }

  tags = var.server_preemptible_tag

  vendor_options {
    ignore_resize_confirmation = true
  }

  dynamic "scheduler_hints" {
    for_each = var.server_group_id != "" ? [var.server_group_id] : []
    content {
      group = var.server_group_id
    }
  }
  
  user_data = var.user_data
}

# resource "openstack_networking_floatingip_associate_v2" "association_1" {
#   port_id     = openstack_networking_port_v2.port_1.id
#   floating_ip = var.public_ip
# }
