variable "env" {
  type    = string
  default = "dev"
}

variable "kube_config_path" {
  type    = string
  default = "kube_config.yml"
}

variable "swarm_private_key" {
  type        = string
  description = "Base64 encoded private key PEM."
  sensitive   = true
}
