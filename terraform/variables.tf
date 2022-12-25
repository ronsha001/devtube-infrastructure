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
  type = list
  default = []
}
variable "react-app-id" {
  type = list
  default = []
}
variable "react-auth-domain" {
  type = list
  default = []
}
variable "react-messaging-senderId" {
  type = list
  default = []
}
variable "react-project-id" {
  type = list
  default = []
}
variable "react-storage-bucket" {
  type = list
  default = []
}
variable "jwt-key" {
  type = list
  default = []
}
variable "root-user" {
  type = list
  default = []
}
variable "root-password" {
  type = list
  default = []
}
variable "my-ssh" {
  type = string
  default = ""
}
variable "argo-password" {
  type = list
  default = []
}