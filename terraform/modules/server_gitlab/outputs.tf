output "server_id" {
  value = openstack_compute_instance_v2.instance_1.id
}

output "server_port_id" {
  value = openstack_networking_port_v2.port_1.id
}

output "server_root_volume_id" {
  value = openstack_blockstorage_volume_v3.boot_volume.id
}

output "floating_ip" {
  # value = module.floatingip.floatingip_address
  value = var.public_ip
}

output "nat_ip" {
  value = openstack_networking_port_v2.port_1.all_fixed_ips
}

output "network_name" {
  value = openstack_networking_port_v2.port_1.name
}

output "network_id" {
  value = openstack_networking_port_v2.port_1.network_id
}