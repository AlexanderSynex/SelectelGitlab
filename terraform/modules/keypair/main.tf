# Создание SSH-ключа
resource "openstack_compute_keypair_v2" "key_tf" {
  name       = var.keypair_name
  region     = var.region
  public_key = var.keypair_public_key
}