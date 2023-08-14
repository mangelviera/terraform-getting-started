### BASIC CONFIG
variable "name" { default = null }
variable "region" { default = null }
variable "profile" { default = null }

### RDS
variable "db_name" { default = null }
variable "username" { default = null }
variable "is_prod" {
  type = bool
  default = null
}

### TAGS
variable "default_tags" {
  type    = map(any)
  default = {}
}

locals {
  current_identity = data.aws_caller_identity.current.arn
}