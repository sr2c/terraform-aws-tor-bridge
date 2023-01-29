variable "contact_info" {
  type        = string
  description = "Contact information to be published in the bridge descriptor."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance size."
  default     = "t3.small"
}

variable "ami" {
  type        = string
  description = "ID of an alternative AMI to use for the EC2 instance. The latest Debian 11 AMI will be used if left unset."
  default     = null
}

variable "ami_owner" {
  type        = string
  description = "The owner ID of the AMI. The Debian organisation's ID will be used if left unset."
  default     = null
}

variable "ssh_private_key" {
  type        = string
  description = "Filename of private SSH key for provisioning."
}

variable "ssh_public_key" {
  type        = string
  description = "Filename of public SSH key for provisioning."
}

variable "ssh_user" {
  type        = string
  description = "Username to use for SSH access (must have password-less sudo enabled)."
  default     = "admin"
}

variable "distribution_method" {
  type        = string
  description = "Bridge distribution method"
  default     = "any"

  validation {
    condition     = contains(["https", "moat", "email", "none", "any"], var.distribution_method)
    error_message = "Invalid distribution method. Valid choices are https, moat, email, none or any."
  }
}
