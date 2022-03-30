variable "contact_info" {
  type = string
  description = "Contact information to be published in the bridge descriptor."
}

variable "bundle_id" {
  type = string
  description = "Bundle ID to use for the Lightsail instance."
  default = "micro_2_0"
}

variable "blueprint" {
  type = string
  description = "Blueprint ID to use for the compute instance (must be Debian 11 based)."
  default = "Debian 11"
}

variable "availability_zone" {
  type = string
  description = "Availability zone to deploy the instance in."
  default = "us-east-1a"
}

variable "ssh_key" {
  type = string
  description = "Public SSH key for provisioning."
}

variable "distribution_method" {
  type = string
  description = "Bridge distribution method"
  default = "any"

  validation {
    condition     = contains(["https", "moat", "email", "none", "any"], var.distribution_method)
    error_message = "Invalid distribution method. Valid choices are https, moat, email, none or any."
  }
}