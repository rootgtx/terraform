resource "oci_core_instance" "OracleLinux87" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_ocid
  display_name        = var.instance_name
  shape               = var.shape

  source_details {
    source_type = "image"
    source_id   = "<oracle_linux_87_image_ocid>"
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.example.id
    assign_public_ip = true
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
}

resource "oci_core_vcn" "example" {
  compartment_id = var.compartment_ocid
  cidr_block     = "10.0.0.0/16"
  display_name   = "example-vcn"
}

resource "oci_core_subnet" "example" {
  compartment_id      = var.compartment_ocid
  vcn_id              = oci_core_vcn.example.id
  availability_domain = var.availability_domain
  cidr_block          = "10.0.1.0/24"
  display_name        = "example-subnet"
  security_list_ids   = [oci_core_security_list.example.id]
}

resource "oci_core_security_list" "example" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.example.id

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  ingress_security_rules {
    source   = "0.0.0.0/0"
    protocol = "6"
    tcp_options {
      min = 22
      max = 22
    }
  }

  ingress_security_rules {
    source   = "0.0.0.0/0"
    protocol = "1"
    icmp_options {
      type = 8
      code = 0
    }
  }
}
