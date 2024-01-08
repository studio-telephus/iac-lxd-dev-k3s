output "haproxy_stats_auth_password" {
  value = random_password.haproxy_stats_auth_password.result
}
