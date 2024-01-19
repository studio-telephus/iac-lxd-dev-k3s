terraform {
  backend "s3" {}
  required_providers {
    bitwarden = {
      source  = "maxlaverse/bitwarden"
      version = "~> 0.7"
    }
  }
}
