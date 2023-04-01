terraform {
  required_providers {
    oci = {
      source = "hashicorp/oci"
      version = ">= 4.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = "<your_tenancy_ocid>"
  user_ocid        = "<your_user_ocid>"
  fingerprint      = "<your_fingerprint>"
  private_key_path = "<path_to_your_private_key>"
  region           = "<your_region>"
}
