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
variable "address_space" {
  type    = list(any)
  default = ["example"]
}
variable "address_prefixes" {
  type    = list(any)
  default = ["example"]
}
variable "public_ip_allocation_method" {
  type    = string
  default = "example"
}
variable "private_ip_address_allocation" {
  type    = string
  default = "example"
}
variable "vm_size" {
  type    = string
  default = "example"
}
variable "admin_username" {
  type    = string
  default = "example"
}
variable "custom_data" {
  type    = string
  default = "example"
}

variable "admin_ssh_key_username" {
  type    = string
  default = "example"
}
variable "public_key_path" {
  type    = string
  default = "example"
}
variable "os_disk_chaching" {
  type    = string
  default = "example"
}
variable "storage_account_type" {
  type    = string
  default = "example"
}
variable "publisher" {
  type    = string
  default = "example"
}
variable "offer" {
  type    = string
  default = "example"
}
variable "sku" {
  type    = string
  default = "example"
}
variable "image_version" {
  type    = string
  default = "example"
}
variable "acr_scope" {
  type    = string
  default = "example"
}