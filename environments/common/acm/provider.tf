# AWS Provider
provider "aws" {
  region = var.region
}

terraform {
  required_version = ">=0.15"
  backend "s3" {}

  required_providers {
    aws = {
      version = "~>3.0"
    }
  }

}
