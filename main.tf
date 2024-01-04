locals {
  cluster_domain   = "cluster.local"
  tls_san          = "k3s-cluster.${var.env}.acme.corp"
  profile_privileged_name = "k3s-privileged-${var.env}"
  container_profiles = [
    "limits",
    "fs-dir",
    "nw-${var.env}",
    local.profile_privileged_name
  ]
  containers_master = [
    {
      name         = "container-${var.env}-k3s-m1"
      ipv4_address = "10.20.0.11"
      profiles     = local.container_profiles
    }
  ]
  containers_worker = [
    {
      name         = "container-${var.env}-k3s-w1"
      ipv4_address = "10.20.0.21"
      profiles     = local.container_profiles
    }
  ]
}

module "lxd_k3s_privileged_profile" {
  source = "github.com/studio-telephus/terraform-lxd-k3s-privileged-profile.git?ref=1.0.0"
  name   = local.profile_privileged_name
}

module "lxd_k3s_cluster" {
  source            = "github.com/studio-telephus/terraform-lxd-k3s-cluster.git?ref=main"
  swarm_private_key = var.swarm_private_key
  cluster_domain    = local.cluster_domain
  nicparent         = "${var.env}-network"
  cidr_pods         = "10.20.10.0/22"
  cidr_services     = "10.20.15.0/22"
  k3s_install_env_vars = {
    "K3S_KUBECONFIG_MODE" = "644"
  }
  global_flags = [
    "--tls-san ${local.tls_san}"
  ]
  master_flags = [
    "--flannel-backend=none"
  ]
  containers_master = local.containers_master
  containers_worker = local.containers_worker
  autostart         = true
  depends_on        = [module.lxd_k3s_privileged_profile]
}

resource "local_file" "kube_config" {
  content    = module.lxd_k3s_cluster.k3s_kube_config
  filename   = var.kube_config_path
  depends_on = [module.lxd_k3s_cluster]
}
