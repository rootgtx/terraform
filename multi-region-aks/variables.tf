variable "resource_group_name" {
  description = "The name of the resource group in which to create the Kubernetes cluster."
  type        = string
}

variable "cluster_name" {
  description = "The name of the Kubernetes cluster."
  type        = string
}

variable "locations" {
  description = "A list of Azure regions for the Kubernetes cluster."
  type        = list(string)
}

variable "node_count" {
  description = "The number of nodes in each node pool."
  default     = 3
  type        = number
}

variable "vm_size" {
  description = "The size of the virtual machines in the node pool."
  default     = "Standard_D2_v2"
  type        = string
}
