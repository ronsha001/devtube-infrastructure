variable "subscription_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000000"
}
variable "project" {
  type    = string
  default = "devtube"
}
variable "creation_date" {
  type    = string
  default = "25/12/2022"
}
variable "expiration_date" {
  type    = string
  default = "01/01/2023"
}
variable "created_by" {
  type    = string
  default = "Ron"
}
variable "made_by" {
  type    = string
  default = "Terraform"
}

variable "react-api-key" {
  type    = list(any)
  default = []
}
variable "react-app-id" {
  type    = list(any)
  default = []
}
variable "react-auth-domain" {
  type    = list(any)
  default = []
}
variable "react-messaging-senderId" {
  type    = list(any)
  default = []
}
variable "react-project-id" {
  type    = list(any)
  default = []
}
variable "react-storage-bucket" {
  type    = list(any)
  default = []
}
variable "jwt-key" {
  type    = list(any)
  default = []
}
variable "root-user" {
  type    = list(any)
  default = []
}
variable "root-password" {
  type    = list(any)
  default = []
}
variable "my-ssh" {
  type    = string
  default = ""
}
variable "argo-password" {
  type    = list(any)
  default = []
}