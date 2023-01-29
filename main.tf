locals {
  ami       = coalesce(var.ami, data.aws_ami.debian.id)
  ami_owner = coalesce(var.ami_owner, data.aws_ami.debian.owner_id)
}

resource "random_integer" "obfs_port" {
  min = 1025
  max = 65535
}

resource "random_integer" "or_port" {
  min = 1025
  max = 65535
}

module "torrc" {
  source                       = "sr2c/torrc/null"
  version                      = "0.0.4"
  bridge_relay                 = 1
  or_port                      = random_integer.or_port.result
  server_transport_plugin      = "obfs4 exec /usr/bin/obfs4proxy"
  server_transport_listen_addr = "obfs4 0.0.0.0:${random_integer.obfs_port.result}"
  ext_or_port                  = "auto"
  contact_info                 = var.contact_info
  nickname                     = replace(title(module.this.id), module.this.delimiter, "")
  bridge_distribution          = var.distribution_method
}

module "cloudinit" {
  source  = "sr2c/tor/cloudinit"
  version = "0.1.0"

  torrc              = module.torrc.rendered
  install_obfs4proxy = true
}

resource "aws_key_pair" "this" {
  public_key = file(var.ssh_public_key)
}

resource "aws_security_group" "obfs4" {
  name   = "${module.this.id}-obfs4"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "obfs4" {
  # This must be defined separately as the port number isn't known until after apply
  # and that messes up the ec2-instance module.
  security_group_id = aws_security_group.obfs4.id
  description       = "Allow access to obfs4 port"
  type              = "ingress"
  from_port         = random_integer.obfs_port.result
  to_port           = random_integer.obfs_port.result
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

module "instance" {
  source  = "cloudposse/ec2-instance/aws"
  version = "0.45.2"

  context    = module.this.context
  attributes = ["instance"]

  subnet = data.aws_subnet.default.id
  vpc_id = data.aws_vpc.default.id

  instance_type = var.instance_type
  ami           = local.ami
  ami_owner     = local.ami_owner

  security_groups = [aws_security_group.obfs4.id]
  security_group_rules = [
    {
      "description" : "Allow all outbound traffic",
      "type" : "egress",
      "from_port" : 0,
      "to_port" : 65535,
      "protocol" : "-1",
      "cidr_blocks" : ["0.0.0.0/0"]
    },
    {
      "description" = "Allow SSH access",
      "type"        = "ingress",
      "from_port"   = 22,
      "to_port"     = 22,
      "protocol"    = "tcp",
      "cidr_blocks" = ["0.0.0.0/0"]
    },
  ]

  associate_public_ip_address = true

  ssh_key_pair     = aws_key_pair.this.key_name
  user_data_base64 = module.cloudinit.rendered
}

resource "null_resource" "wait_for_cloud_init" {
  depends_on = [module.instance]

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "sleep 30" # Give tor and obfs4proxy time to generate keys and state
    ]
  }

  connection {
    host        = module.instance.public_ip
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.ssh_private_key)
    timeout     = "10m"
  }
}

module "bridgeline" {
  source  = "matti/resource/shell"
  version = "1.5.0"

  command = "ssh -o StrictHostKeyChecking=no -i ${var.ssh_private_key} ${var.ssh_user}@${module.instance.public_ip} sudo cat /var/lib/tor/pt_state/obfs4_bridgeline.txt | tail -n 1"

  depends_on = [null_resource.wait_for_cloud_init]
}

module "fingerprint_ed25519" {
  source  = "matti/resource/shell"
  version = "1.5.0"

  command = "ssh -o StrictHostKeyChecking=no -i ${var.ssh_private_key} ${var.ssh_user}@${module.instance.public_ip} sudo cat /var/lib/tor/fingerprint-ed25519"

  depends_on = [null_resource.wait_for_cloud_init]
}

module "fingerprint_rsa" {
  source  = "matti/resource/shell"
  version = "1.5.0"

  command = "ssh -o StrictHostKeyChecking=no -i ${var.ssh_private_key} ${var.ssh_user}@${module.instance.public_ip} sudo cat /var/lib/tor/fingerprint"

  depends_on = [null_resource.wait_for_cloud_init]
}

module "hashed_fingerprint" {
  source  = "matti/resource/shell"
  version = "1.5.0"

  command = "ssh -o StrictHostKeyChecking=no -i ${var.ssh_private_key} ${var.ssh_user}@${module.instance.public_ip} sudo cat /var/lib/tor/hashed-fingerprint"

  depends_on = [null_resource.wait_for_cloud_init]
}
