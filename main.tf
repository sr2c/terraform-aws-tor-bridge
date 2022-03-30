resource "random_integer" "obfs_port" {
  min = 1025
  max = 65535
}

resource "random_integer" "or_port" {
  min = 1025
  max = 65535
}

resource "aws_lightsail_key_pair" "this" {
  name       = "${module.this.id}-keypair"
  public_key = var.ssh_key
}

module "torrc" {
  source = "sr2c/torrc/null"
  version = "0.0.4"
  bridge_relay = 1
  or_port = random_integer.or_port.result
  server_transport_plugin = "obfs4 exec /usr/bin/obfs4proxy"
  server_transport_listen_addr = "obfs4 0.0.0.0:${random_integer.obfs_port.result}"
  ext_or_port = "auto"
  contact_info = var.contact_info
  nickname = replace(title(module.this.id), module.this.delimiter, "")
  bridge_distribution = var.distribution_method
}

resource "aws_lightsail_instance" "this" {
  name              = module.this.id
  availability_zone = var.availability_zone
  blueprint_id      = "debian_10"
  bundle_id         = "micro_2_0"
  key_pair_name     = aws_lightsail_key_pair.this.name
  tags = module.this.tags

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt upgrade -y",
      "sudo apt install -y apt-transport-https gnupg2",
      "echo 'deb     [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org buster main' | sudo tee /etc/apt/sources.list.d/tor.list",
      "echo 'deb-src [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org buster main' | sudo tee -a /etc/apt/sources.list.d/tor.list",
      "wget -O- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | sudo tee /usr/share/keyrings/tor-archive-keyring.gpg >/dev/null",
      "sudo apt update",
      "sudo apt install -y tor tor-geoipdb deb.torproject.org-keyring obfs4proxy"
    ]
  }

  provisioner "file" {
    content = module.torrc.rendered
    destination = "/home/${self.username}/torrc"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /home/${self.username}/torrc /etc/tor/torrc",
      "sudo chown root:root /etc/tor/torrc",
      "sudo chmod 644 /etc/tor/torrc",
      "sudo systemctl restart tor"
    ]
  }

  lifecycle {
    ignore_changes = [
      blueprint_id,
      bundle_id,
      user_data
    ]
  }

  connection {
    host = self.public_ip_address
    type = "ssh"
    user = self.username
    timeout = "5m"
  }
}

module "bridgeline" {
  source  = "matti/resource/shell"
  version = "1.5.0"
  command = "ssh -o StrictHostKeyChecking=no ${aws_lightsail_instance.this.username}@${aws_lightsail_instance.this.public_ip_address} sudo cat /var/lib/tor/pt_state/obfs4_bridgeline.txt | tail -n 1"
}

module "fingerprint_ed25519" {
  source  = "matti/resource/shell"
  version = "1.5.0"
  command = "ssh -o StrictHostKeyChecking=no ${aws_lightsail_instance.this.username}@${aws_lightsail_instance.this.public_ip_address} sudo cat /var/lib/tor/fingerprint-ed25519"
}

module "fingerprint_rsa" {
  source  = "matti/resource/shell"
  version = "1.5.0"
  command = "ssh -o StrictHostKeyChecking=no ${aws_lightsail_instance.this.username}@${aws_lightsail_instance.this.public_ip_address} sudo cat /var/lib/tor/fingerprint"
}

module "hashed_fingerprint" {
  source  = "matti/resource/shell"
  version = "1.5.0"
  command = "ssh -o StrictHostKeyChecking=no ${aws_lightsail_instance.this.username}@${aws_lightsail_instance.this.public_ip_address} sudo cat /var/lib/tor/hashed-fingerprint"
}