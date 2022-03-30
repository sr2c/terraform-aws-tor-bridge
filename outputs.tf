output "ansible_inventory" {
  value = "${module.this.id} ansible_user=${aws_lightsail_instance.this.username} ansible_host=${aws_lightsail_instance.this.public_ip_address}"
  sensitive = true
  description = "An Ansible inventory line that allows login to the bridge with the correct username."
}

output "bridgeline" {
  value = replace(
            replace(
              replace(module.bridgeline.stdout,
                "<IP ADDRESS>", aws_lightsail_instance.this.public_ip_address),
              "<PORT>", tostring(random_integer.obfs_port.result)),
            "<FINGERPRINT>", module.fingerprint_rsa.stdout)
  sensitive = true
  description = "The bridgeline that would allow a Tor client to use this bridge."
}

output "fingerprint_ed25519" {
  value = module.fingerprint_ed25519.stdout
  sensitive = true
  description = "The Ed25519 fingerprint of this bridge."
}

output "fingerprint_rsa" {
  value = module.fingerprint_rsa.stdout
  sensitive = true
  description = "The hex-encoded RSA fingerprint of this bridge."
}

output "hashed_fingerprint" {
  value = module.hashed_fingerprint.stdout
  description = "The hex-encoded hashed fingerprint of this bridge. This is used to identify the bridge in public Tor Metrics data."
}

output "ip_address" {
  value = aws_lightsail_instance.this.public_ip_address
  sensitive = true
  description = "The IP address of the server. This is treated as sensitive as this information may be used to censor access to the bridge."
}

output "id" {
  value = module.this.id
  description = "An identifier for the bridge formed of the ID elements."
}

output "nickname" {
  value = replace(title(module.this.id), module.this.delimiter, "")
  description = "The nickname of the bridge published in the bridge descriptors. This is based on the ID, reformatted for the nickname restrictions."
}

output "or_port" {
  value = random_integer.or_port.result
  sensitive = true
  description = "The TCP port number used for the OR port. This is treated as sensitive as this information may be used to censor access to the bridge."
}

output "obfs_port" {
  value = random_integer.obfs_port.result
  sensitive = true
  description = "The TCP port number used for the obfs4 port. This is treated as sensitive as this information may be used to censor access to the bridge."
}

output "ssh_user" {
  value = aws_lightsail_instance.this.username
  description = "The username used for SSH access."
}