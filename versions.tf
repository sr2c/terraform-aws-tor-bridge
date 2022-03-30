terraform {
  required_version    = ">= 1.0.11"
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.1.0"
    }
    openstack = {
      source  = "hashicorp/aws"
      version = "~> 4.2.0"
    }
  }
}