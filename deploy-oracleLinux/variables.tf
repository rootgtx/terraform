variable "compartment_ocid" {
  description = "The OCID of the compartment where resources will be created."
}

variable "instance_name" {
  description = "The name of the instance to create."
  default     = "OracleLinux87"
}

variable "availability_domain" {
  description = "The availability domain where the instance will be created."
}

variable "shape" {
  description = "The shape of the instance."
  default     = "VM.Standard.E3.Flex"
}

variable "ssh_public_key" {
  description = "The SSH public key for the instance."
}
