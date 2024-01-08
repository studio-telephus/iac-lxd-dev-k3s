terraform {
  backend "s3" {}
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
  }
}
