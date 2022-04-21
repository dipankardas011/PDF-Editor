terraform {
  required_providers {
    heroku = {
      source = "heroku/heroku"
      version = "5.0.2"
    }
  }
}

provider "heroku" {
  # Configuration options
}