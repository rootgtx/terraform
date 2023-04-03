output "kube_config" {
  value     = module.kubernetes.kube_config
  sensitive = true
}

output "node_pool_ids" {
  value = {
    for pool in module.kubernetes.node_pools : pool.name => pool.id
  }
}
