terraform {
  required_providers {
    heroku = {
      source = "heroku/heroku"
      version = "5.0.2"
    }
  }
}

provider "heroku" {
  email   = "ops@company.com"
  api_key = var.heroku_api_key
}

# Create a new application
resource "heroku_app" "default" {
}