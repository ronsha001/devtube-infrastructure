variable "project" {
  type    = string
  default = "example"
}
variable "creation_date" {
  type    = string
  default = "example"
}
variable "expiration_date" {
  type    = string
  default = "example"
}
variable "created_by" {
  type    = string
  default = "example"
}
variable "made_by" {
  type    = string
  default = "example"
}
variable "rg_location" {
  type    = string
  default = "example"
}
variable "kubernetes_version" {
  type    = string
  default = "example"
}
variable "dns_prefix" {
  type    = string
  default = "example"
}
variable "default_node_pool_name" {
  type    = string
  default = "example"
}
variable "default_node_pool_nodes" {
  type    = number
  default = 3
}
variable "default_node_pool_vm_size" {
  type    = string
  default = "example"
}
variable "default_node_pool_min_count" {
  type    = number
  default = 1
}
variable "default_node_pool_max_count" {
  type    = number
  default = 3
}
variable "enable_auto_scaling" {
  type    = bool
  default = true
}
variable "identity_type" {
  type    = string
  default = "example"
}
variable "argocd_version" {
  type    = string
  default = "example"
}
variable "argocd_values_file_path" {
  type    = string
  default = "example"
}
variable "cert_manager_version" {
  type    = string
  default = "example"
}
variable "external_secrets_version" {
  type    = string
  default = "example"
}
variable "ingress_nginx_version" {
  type    = string
  default = "example"
}
variable "acr_scope" {
  type    = string
  default = "example"
}