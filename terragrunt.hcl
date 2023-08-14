terraform {
  source = "./terraform"
}

remote_state {
  backend = "s3"
  config = {
    profile        = "TO_BE_DEFINED"
    bucket         = "TO_BE_DEFINED-coffee-shop-terraform-state"
    region         = "eu-west-1"
    encrypt        = true
    key            = "terraform.tfstate"
  }
}

inputs = {
  name           = "TO_BE_DEFINED"
  region         = "eu-west-1"
  env            = "pro"
  profile        = "TO_BE_DEFINED"
  is_prod        = true

  db_name       = "TO_BE_DEFINED"
  username      = "TO_BE_DEFINED"

  default_tags = {
    Owner       = "TO_BE_DEFINED"
    Environment = "pro"
  }
}